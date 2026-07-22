# Initial lockup
This repository is a greenland, with almost ZERO things implemented yet and you will implement everything.
We will first build the server totally, 100%, and, only then we will go to the frontend client part.

# Initial context
In a short: I want to build a saas where the users will be able to talk with a AI in a chat-bot like style in order to generate PDF's template and receive a REST endpoint that they can then call to generate PDF on top of the template created. So, with a given payload, based on the template they previously builted with AI in the chat interation, the will receive the pdf.

Why I want to create this?
Some companies need generate to generate PDF for there clients (this is the pain). Most of them have a template that they manually edit or that is automated to receive a payload of data (that represents the dynamic data that will change between one pdf and other) and with that they generate the pdf. But there is no real good solution here because creating that pdf is a pain in the ass and mantaining it as well. More then that: The core-business of those companies is not handling the infra to generate pdf's (that is a costly things in terms of computing power), so most of them try solutions like [pdfforge](https://apitemplate.io/) or [pdfgeneratorapi](https://pdfgeneratorapi.com/) and much other's that exist but all of them are based in you mannualy inputing the pdf html/css and this might be tuff for non tecnical people. And the pdf generated are quite bad loking in terms of ui.

# Key differentiators
The main differentiators between the saas that I want you to build and the ones that already exists are, mainly, two:
- Low friction to have a working template.
- Easy to understand UI for less-tecnical people.
- The possibility to actually see the template/product before paying anything.
- The possibility of auto-translating the pdf to multiple languages.
- Support for easy template editing (version system)

# Core PDF versioning logic
A problem in having a fixed pdf template is:
The other saas do the same proccess of "receive a payload and build the pdf with this".
But the main point is: What if I added a new page that needs new info from the payload, what will happen with outdated clients?
It will break? 
In order to not break for old clients that will not be sending this data, the template will, probably, have in his logic, something like: "If the new data, show new pdf page with that data. If not present, dont show that page at all."
This seems to work in a first moment, but it is not sustainable.
Think if after the fix now there is a new demand with new data in the payload... But now, this new data will be displayed in a page that already exists...
So, there will be a logic of "If this data exists, then it show 'X' component, otherwise show the old component 'Y' that does not have this data".
This is going to be a maintenance nightmare in the future.
Just imagine the amount of "if's" logics that will be acumulated in the time.
Quicly the template will be in a state very hard to read for humans, and even for other AI's to understand the mess that is happening so they don't broke any client in there next iteration on that template. A real castle of cards.

For that reason, I had think in a "versioned schema-drived payload" approach. That is the "secret sauce" that will save this mess.
In a short:
When the user edits a template only visually (changing display of informations, without data change, only ui tweak), in a way that no input payload variable is removed/added, then we will just UPDATE the current template.
On the other hand, if the user changes the payload (asks in the chat bot ui to add a new page with more data, or asks to add new data to a existing component), then it will create a new VERSION of the template and the url to save that new version will also change.
A new version with a new schema for a template that expects a new payload entry.

So this is the perfect approach.
Since PDF's templates are built in real time (and not cached), then a "only ui tweak" will be reflected for anyone that opens a pdf url pre-generated. So, if I have a link that points to a pdf and then the template of that pdf changes, the users will continue to click in the same link and, now, a different pdf will be rendered in there browser, with the new changes/ui. This is awesome.
But, if the payload changes, then the old pdf generated will continue to point to the same template, and only new generated pdf will point to the newest version of the pdf since this version is for pdf generated with a different state of entries.

## Technical implementation
From the technical point of view, this structure described above will be represented by some "spy.yaml" models and I will explain you how this will work.

The base of everything is the [SiriusTemplate](/Users/igor/PersonalProjects/sirius/sirius_server/lib/src/entities/pdf_core/sirius_template.spy.yaml) model. 
It will handle all versions of the pdf, from the first old legacy one to the newest version.
Since it is the root of everything, it will also carry other information other than the versions of template implementations – like the [TemplateDisplayInfo](/Users/igor/PersonalProjects/sirius/sirius_server/lib/src/entities/pdf_core/template_entities/template_display_info.spy.yaml) model that carries information (such as name and description) that helps the user to identify the template in the dashboard. The root model is also attached deeply by a relationship to whoever created by the account model [AccountInfo](/Users/igor/PersonalProjects/sirius/sirius_server/lib/src/entities/others/account.spy.yaml) .

Now, let's go to the templates itself.
A version of a template is represented by the `TemplateSchemaVersion` model.
Remembering: A new version is generated when the schema changed (now it is a new schema). And that schema is represented by the `SchemaDefinition` [schema_definition.spy.yaml](/Users/igor/PersonalProjects/sirius/sirius_server/lib/src/entities/pdf_core/schema_definition.spy.yaml)  model that is attached to the `TemplateSchemaVersion` model.

We will use jinja2 template to build the pdf's.
The template is saved in `TemplateEngineInput`, this is literally what defines the pdf template (number of pages, theme, literally everything).
The Jinja2 template needs 2 things: the html template and the css content.

That html/css template is only expecting a json input in order to generate a pdf.

When the user tries to apply a input json to the template to generate a pdf, we treat this in the system as an implementation of the schema template (the template of the url that the user is hitting in the request).
So, thats why the `TemplateSchemaVersion` is attached to a lot of implementations of it, the `SiriusTemplateImplementationGateway` at 
[sirius_version_implementation_gateway.spy.yaml](/Users/igor/PersonalProjects/sirius/sirius_server/lib/src/entities/pdf_core/implementation/sirius_version_implementation_gateway.spy.yaml) .
So, those are the models that hold the inputs that will be used to generate the pdf in real time (yes, the pdf is will be generated in real time – I will talk about this later in the promtp in the "## Real time generation" section).

But, you will notice that the implementation model has a suffix "Gateway".
The reason for this comes from the following logic: 
The template that will be generated with AI, with 

## Real time generation
So, every 

```dart
import 'dart:io';
import 'package:serverpod/serverpod.dart';

Future<Response> handlePdfRequest(Request request) async {
  final file = File('path/to/file.pdf');
  final fileSize = await file.length();
  final stream = file.openRead().map((chunk) => Uint8List.fromList(chunk));

  return Response.ok(
    body: Body.fromDataStream(
      stream,
      mimeType: MimeType.pdf,
      contentLength: fileSize, // Recommended for better HTTP performance
    ),
  );
}
```

But, the implementation is not the direct model.