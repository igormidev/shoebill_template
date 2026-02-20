#!/bin/bash
# Post-generate script to fix Serverpod sealed class code generation bug.
# Run this after `serverpod generate` to re-add the missing _Undefined class.
#
# Usage:
#   serverpod generate && ./post_generate.sh
#
# Background:
#   Serverpod's code generator creates copyWith methods in child (part) files
#   that reference _Undefined, but doesn't emit the _Undefined class in the
#   sealed parent file. This script appends it to the affected files.

set -e

UNDEFINED_BLOCK='
// Workaround: Serverpod sealed class code generation bug.
class _Undefined {}'

FILES=(
  "shoebill_template_server/lib/src/generated/api/pdf_related/entities/schemas_implementations/schema_property.dart"
  "shoebill_template_client/lib/src/protocol/api/pdf_related/entities/schemas_implementations/schema_property.dart"
)

for file in "${FILES[@]}"; do
  if [ -f "$file" ] && ! grep -q 'class _Undefined' "$file"; then
    echo "$UNDEFINED_BLOCK" >> "$file"
    echo "Patched: $file"
  else
    echo "Already patched or not found: $file"
  fi
done
