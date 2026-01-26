import 'dart:typed_data';

import 'package:jinja/jinja.dart';
import 'package:puppeteer/puppeteer.dart';
import 'package:shoebill_template_server/src/generated/protocol.dart';

/// A mixin that provides Jinja2 template rendering and PDF generation capabilities.
///
/// This mixin combines the `jinja` package (a Dart port of the Jinja2 template engine)
/// with the `puppeteer` package (headless Chrome automation) to render HTML/CSS templates
/// into high-quality PDF documents.
///
/// ## Architecture
///
/// The rendering pipeline works as follows:
/// 1. A Jinja2 HTML template is rendered with the provided payload data and language context
/// 2. The rendered HTML is combined with the CSS stylesheet into a complete HTML document
/// 3. Headless Chrome (via Puppeteer) renders the full document and exports it as a PDF
///
/// ## Browser Lifecycle
///
/// The browser instance is lazily created on the first render call and reused for all
/// subsequent renders. Each render creates a new page (tab) within the shared browser,
/// which is closed after the PDF is generated. Call [disposeBrowser] to shut down the
/// browser when the service is being torn down.
///
/// ## Usage Example
///
/// ```dart
/// class PdfService with JinjaPdfRendererMixin {
///   Future<Uint8List> generateInvoicePdf(Map<String, dynamic> invoiceData) async {
///     const htmlTemplate = '''
///     <div class="invoice-header">
///       <h1>{{ company_name }}</h1>
///       <p>Invoice #{{ invoice_number }}</p>
///     </div>
///     <table class="line-items">
///       {% for item in items %}
///       <tr>
///         <td>{{ item.description }}</td>
///         <td>{{ item.amount }}</td>
///       </tr>
///       {% endfor %}
///     </table>
///     <div class="total">
///       <p>Total: {{ currency }} {{ total }}</p>
///     </div>
///     ''';
///
///     const cssContent = '''
///     body { font-family: "Noto Sans CJK", sans-serif; }
///     .invoice-header { text-align: center; margin-bottom: 2rem; }
///     .line-items { width: 100%; border-collapse: collapse; }
///     .line-items td { border: 1px solid #ddd; padding: 8px; }
///     .total { text-align: right; font-weight: bold; margin-top: 1rem; }
///     ''';
///
///     return renderPdfFromJinja(
///       htmlTemplate: htmlTemplate,
///       cssContent: cssContent,
///       payload: invoiceData,
///       language: SupportedLanguage.english,
///     );
///   }
/// }
/// ```
///
/// ## Multi-language Support
///
/// The `language` parameter is injected into the template context as `language`,
/// allowing templates to implement language-specific rendering:
///
/// ```html
/// <h1>
///   {% if language == "japanese" %}
///     ご請求書
///   {% elif language == "brazilianPortuguese" %}
///     Fatura
///   {% else %}
///     Invoice
///   {% endif %}
/// </h1>
/// ```
///
/// ## Font Support
///
/// The default font is "Noto Sans CJK" which provides comprehensive Unicode coverage
/// including CJK (Chinese, Japanese, Korean) characters. This is loaded via Google Fonts
/// CDN to ensure availability without local font installation. Templates can override
/// this by specifying their own font-family in their CSS.
///
/// ## Error Handling
///
/// The mixin throws [ShoebillException] with descriptive titles and messages for:
/// - Template syntax errors (malformed Jinja2 syntax)
/// - Missing required template variables
/// - Browser launch failures
/// - PDF generation failures
/// - Invalid or empty template/CSS content
/// - CSS content containing potential injection patterns
///
/// ## Security
///
/// CSS content is sanitized before being embedded in the HTML document. Any content
/// that could break out of the `<style>` tag context (e.g., `</style>`) is rejected
/// to prevent HTML/script injection attacks.
mixin JinjaPdfRendererMixin {
  // ─── Font Configuration ─────────────────────────────────────────────────

  /// The default font family used in PDF rendering.
  ///
  /// "Noto Sans CJK SC" provides comprehensive Unicode support including
  /// Latin, Cyrillic, CJK (Chinese, Japanese, Korean), and many other scripts.
  /// This ensures proper rendering for all [SupportedLanguage].
  static const String _kDefaultFontFamily = 'Noto Sans CJK SC';

  /// The Google Fonts CDN URL for loading Noto Sans SC (Simplified Chinese variant
  /// that also covers Latin, Cyrillic, and other scripts).
  static const String _kDefaultFontUrl =
      'https://fonts.googleapis.com/css2?family=Noto+Sans+SC:wght@100..900&display=swap';

  // ─── Page Layout Configuration ──────────────────────────────────────────

  /// Default page margins for PDF output in CSS units.
  static const String _kDefaultPageMarginTop = '15mm';
  static const String _kDefaultPageMarginBottom = '15mm';
  static const String _kDefaultPageMarginLeft = '10mm';
  static const String _kDefaultPageMarginRight = '10mm';

  // ─── Timing Configuration ───────────────────────────────────────────────

  /// Maximum time to wait for the page to render before timing out.
  static const Duration _kPageRenderTimeout = Duration(seconds: 30);

  // ─── Browser Configuration ──────────────────────────────────────────────

  /// Chrome launch arguments for headless PDF rendering.
  ///
  /// These flags configure Chrome for server-side, sandboxed rendering:
  /// - `--no-sandbox`: Required for running in containerized environments
  /// - `--disable-setuid-sandbox`: Companion to --no-sandbox
  /// - `--disable-dev-shm-usage`: Prevents /dev/shm exhaustion in Docker
  /// - `--disable-gpu`: GPU not needed for PDF rendering
  /// - `--font-render-hinting=none`: Consistent font rendering across platforms
  static const List<String> _kBrowserArgs = [
    '--no-sandbox',
    '--disable-setuid-sandbox',
    '--disable-dev-shm-usage',
    '--disable-gpu',
    '--font-render-hinting=none',
  ];

  // ─── CSS Sanitization ───────────────────────────────────────────────────

  /// Pattern that detects attempts to break out of a `<style>` tag context.
  ///
  /// Matches `</style` (case-insensitive) which is the minimum needed to close
  /// a style element, regardless of trailing characters (`>`, whitespace, attributes).
  static final RegExp _kStyleBreakoutPattern = RegExp(
    r'<\s*/\s*style',
    caseSensitive: false,
  );

  /// Pattern that detects `<script` tags injected through CSS content.
  static final RegExp _kScriptTagPattern = RegExp(
    r'<\s*script',
    caseSensitive: false,
  );

  // ─── Browser Singleton ──────────────────────────────────────────────────

  /// The shared browser instance, lazily created on first use.
  Browser? _browser;

  /// Returns the shared browser instance, launching one if necessary.
  ///
  /// If the browser was previously closed or disconnected, a new instance
  /// is created transparently.
  Future<Browser> _getOrCreateBrowser() async {
    if (_browser == null || !_browser!.isConnected) {
      _browser = await puppeteer.launch(
        headless: true,
        args: _kBrowserArgs,
      );
    }
    return _browser!;
  }

  /// Disposes the shared browser instance.
  ///
  /// Call this when the service is being shut down to release system resources.
  /// After calling this, the next [renderPdfFromJinja] call will launch a new
  /// browser automatically.
  Future<void> disposeBrowser() async {
    final browser = _browser;
    _browser = null;
    if (browser != null) {
      try {
        await browser.close();
      } catch (_) {
        // Ignore close errors during shutdown
      }
    }
  }

  // ─── Public API ─────────────────────────────────────────────────────────

  /// Renders a PDF document from a Jinja2 HTML template with CSS styling.
  ///
  /// This method performs the complete rendering pipeline:
  /// 1. Validates inputs (non-empty template and CSS)
  /// 2. Sanitizes CSS content to prevent injection attacks
  /// 3. Compiles and renders the Jinja2 template with the payload context
  /// 4. Constructs a full HTML document with embedded CSS and font imports
  /// 5. Uses the shared headless Chrome instance to render and export as PDF
  ///
  /// Parameters:
  /// - [htmlTemplate]: The Jinja2 HTML template string containing template syntax
  ///   (variables `{{ }}`, control structures `{% %}`, etc.)
  /// - [cssContent]: The CSS stylesheet content to apply to the rendered HTML.
  ///   Must not contain HTML tags or attempts to break out of the style context.
  /// - [payload]: A map of variables to inject into the template context.
  ///   All keys become available as top-level variables in the template.
  /// - [language]: The target language for rendering. This is injected into the
  ///   template context as `language` (using the enum's `.name` property).
  ///
  /// Returns a [Uint8List] containing the PDF file bytes.
  ///
  /// Throws [ShoebillException] if:
  /// - The template or CSS content is empty
  /// - The CSS content contains injection patterns (e.g., `</style>`, `<script>`)
  /// - The template contains syntax errors
  /// - A required template variable is missing from the payload
  /// - The browser fails to launch or render
  /// - PDF generation fails for any reason
  Future<Uint8List> renderPdfFromJinja({
    required String htmlTemplate,
    required String cssContent,
    required Map<String, dynamic> payload,
    required SupportedLanguage language,
  }) async {
    // ─── 1. Input Validation ───────────────────────────────────────────
    _validateInputs(htmlTemplate: htmlTemplate, cssContent: cssContent);

    // ─── 2. CSS Sanitization ───────────────────────────────────────────
    _validateCssSafety(cssContent);

    // ─── 3. Render Jinja2 Template ─────────────────────────────────────
    final String renderedHtml = _renderJinjaTemplate(
      htmlTemplate: htmlTemplate,
      payload: payload,
      language: language,
    );

    // ─── 4. Build Full HTML Document ───────────────────────────────────
    final String fullHtmlDocument = _buildFullHtmlDocument(
      renderedBody: renderedHtml,
      cssContent: cssContent,
    );

    // ─── 5. Generate PDF via Headless Chrome ───────────────────────────
    return _generatePdfFromHtml(fullHtmlDocument);
  }

  // ─── Private Implementation ─────────────────────────────────────────────

  /// Validates that the template and CSS inputs are non-empty and usable.
  ///
  /// Throws [ShoebillException] with a descriptive error if validation fails.
  void _validateInputs({
    required String htmlTemplate,
    required String cssContent,
  }) {
    if (htmlTemplate.trim().isEmpty) {
      throw ShoebillException(
        title: 'Empty HTML template',
        description:
            'The HTML template string is empty. A valid Jinja2 HTML template is required to render the PDF.',
      );
    }
    if (cssContent.trim().isEmpty) {
      throw ShoebillException(
        title: 'Empty CSS content',
        description:
            'The CSS content string is empty. A valid CSS stylesheet is required to style the PDF.',
      );
    }
  }

  /// Validates that CSS content does not contain patterns that could break
  /// out of the `<style>` tag context and inject arbitrary HTML or scripts.
  ///
  /// This prevents attacks where CSS content like:
  /// ```
  /// body { color: red; } </style><script>alert('xss')</script><style>
  /// ```
  /// could escape the style context and execute JavaScript.
  ///
  /// Throws [ShoebillException] if unsafe patterns are detected.
  void _validateCssSafety(String cssContent) {
    if (_kStyleBreakoutPattern.hasMatch(cssContent)) {
      throw ShoebillException(
        title: 'Invalid CSS content',
        description:
            'The CSS content contains a closing "</style>" tag pattern, which is not '
            'valid CSS and could indicate an injection attempt. Remove any HTML tags '
            'from the CSS content.',
      );
    }
    if (_kScriptTagPattern.hasMatch(cssContent)) {
      throw ShoebillException(
        title: 'Invalid CSS content',
        description:
            'The CSS content contains a "<script>" tag pattern, which is not '
            'valid CSS and could indicate an injection attempt. Remove any HTML tags '
            'from the CSS content.',
      );
    }
  }

  /// Compiles and renders the Jinja2 template with the payload and language context.
  ///
  /// The template context includes:
  /// - All entries from [payload] as top-level variables
  /// - `language`: The [SupportedLanguage] enum name (e.g., "english", "japanese")
  ///
  /// Throws [ShoebillException] if the template has syntax errors or if
  /// referenced variables are missing from the context.
  String _renderJinjaTemplate({
    required String htmlTemplate,
    required Map<String, dynamic> payload,
    required SupportedLanguage language,
  }) {
    try {
      final environment = Environment(
        // Use standard Jinja2 delimiters
        blockStart: '{%',
        blockEnd: '%}',
        variableStart: '{{',
        variableEnd: '}}',
        commentStart: '{#',
        commentEnd: '#}',
        // Trim whitespace around blocks for cleaner output
        trimBlocks: true,
        leftStripBlocks: true,
      );

      final template = environment.fromString(htmlTemplate);

      // Build the template context with payload + language
      final Map<String, dynamic> context = {
        ...payload,
        'language': language.name,
      };

      return template.render(context);
    } on TemplateSyntaxError catch (e) {
      throw ShoebillException(
        title: 'Template syntax error',
        description:
            'The Jinja2 HTML template contains a syntax error: ${e.message}. '
            'Please check the template for malformed expressions, '
            'unclosed blocks, or invalid filter usage.',
      );
    } on UndefinedError catch (e) {
      throw ShoebillException(
        title: 'Missing template variable',
        description:
            'The template references a variable that is not present in the payload: '
            '${e.message}. Ensure all variables used in the template are included '
            'in the payload map or are handled with default filters.',
      );
    } on TemplateRuntimeError catch (e) {
      throw ShoebillException(
        title: 'Template runtime error',
        description:
            'A runtime error occurred while rendering the Jinja2 template: ${e.message}. '
            'This may be caused by invalid filter usage, type mismatches, '
            'or incorrect control structure logic.',
      );
    } on TemplateError catch (e) {
      throw ShoebillException(
        title: 'Template error',
        description:
            'An error occurred in the Jinja2 template engine: ${e.message}. '
            'Please verify the template syntax and data types.',
      );
    } catch (e) {
      throw ShoebillException(
        title: 'Template rendering failed',
        description:
            'An unexpected error occurred while rendering the Jinja2 template: $e. '
            'This may indicate a problem with template expressions, filters, or data types.',
      );
    }
  }

  /// Constructs a complete HTML document with embedded CSS, font imports,
  /// and the rendered body content.
  ///
  /// The generated document includes:
  /// - UTF-8 charset declaration
  /// - Google Fonts import for "Noto Sans SC" (multi-language support)
  /// - Base styles with the default font family
  /// - Print-specific CSS for page sizing and margins
  /// - The user-provided CSS embedded in a <style> block
  /// - The rendered HTML body content
  ///
  /// **Security note:** The [cssContent] must be validated via [_validateCssSafety]
  /// before being passed to this method.
  String _buildFullHtmlDocument({
    required String renderedBody,
    required String cssContent,
  }) {
    return '''<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="$_kDefaultFontUrl" rel="stylesheet">
  <style>
    /* ─── Base Reset & Defaults ─────────────────────────── */
    *, *::before, *::after {
      box-sizing: border-box;
      margin: 0;
      padding: 0;
    }

    html, body {
      width: 100%;
      height: 100%;
      font-family: "$_kDefaultFontFamily", "Noto Sans", "Helvetica Neue", Arial, sans-serif;
      font-size: 14px;
      line-height: 1.5;
      color: #1a1a1a;
      -webkit-print-color-adjust: exact;
      print-color-adjust: exact;
    }

    /* ─── Print / Page Configuration ────────────────────── */
    @page {
      size: A4;
      margin-top: $_kDefaultPageMarginTop;
      margin-bottom: $_kDefaultPageMarginBottom;
      margin-left: $_kDefaultPageMarginLeft;
      margin-right: $_kDefaultPageMarginRight;
    }

    /* ─── Page Break Utilities ──────────────────────────── */
    .page-break-before { page-break-before: always; }
    .page-break-after { page-break-after: always; }
    .avoid-break { page-break-inside: avoid; }

    /* ─── User-Provided CSS ─────────────────────────────── */
    $cssContent
  </style>
</head>
<body>
$renderedBody
</body>
</html>''';
  }

  /// Uses the shared headless Chrome instance to render the HTML and generate a PDF.
  ///
  /// A new page (tab) is created for each render call and is always closed
  /// after completion, even if an error occurs. The browser itself persists
  /// across calls for efficiency.
  ///
  /// The PDF is generated with:
  /// - A4 paper format
  /// - Print backgrounds enabled (for colors, gradients, images)
  /// - CSS page size preferred (respects @page rules)
  /// - No additional Chrome-added margins (margins come from @page CSS)
  ///
  /// Returns the PDF as a [Uint8List] byte array.
  ///
  /// Throws [ShoebillException] if the browser cannot be launched or
  /// PDF generation fails.
  Future<Uint8List> _generatePdfFromHtml(String fullHtmlDocument) async {
    final Browser browser;
    try {
      browser = await _getOrCreateBrowser();
    } catch (e) {
      throw ShoebillException(
        title: 'Browser launch failed',
        description:
            'Failed to launch headless Chrome for PDF rendering: $e. '
            'Ensure Chrome/Chromium is installed and accessible.',
      );
    }

    Page? page;
    try {
      page = await browser.newPage();

      // Set the HTML content and wait for fonts and resources to load
      await page.setContent(
        fullHtmlDocument,
        wait: Until.networkAlmostIdle,
        timeout: _kPageRenderTimeout,
      );

      // Use print media type for accurate PDF rendering with @page rules
      await page.emulateMediaType(MediaType.print);

      // Generate the PDF
      final Uint8List? pdfBytes = await page.pdf(
        format: PaperFormat.a4,
        printBackground: true,
        preferCssPageSize: true,
        // Margins are handled via @page CSS rule, so set zero here
        margins: PdfMargins.zero,
      );

      if (pdfBytes == null || pdfBytes.isEmpty) {
        throw ShoebillException(
          title: 'PDF generation returned empty result',
          description:
              'The headless browser generated an empty PDF. This may indicate '
              'an issue with the HTML content or CSS styling. Check that the '
              'template produces visible content.',
        );
      }

      return pdfBytes;
    } on ShoebillException {
      rethrow;
    } catch (e) {
      throw ShoebillException(
        title: 'PDF generation failed',
        description:
            'Failed to generate PDF from the rendered HTML document: $e. '
            'This may be caused by network issues loading fonts, or malformed HTML/CSS.',
      );
    } finally {
      // Always close the page to free tab resources, even on error
      if (page != null) {
        try {
          await page.close();
        } catch (_) {
          // Ignore page close errors - best-effort cleanup
        }
      }
    }
  }
}
