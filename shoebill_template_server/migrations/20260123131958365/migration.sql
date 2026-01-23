BEGIN;

--
-- Function: gen_random_uuid_v7()
-- Source: https://gist.github.com/kjmph/5bd772b2c2df145aa645b837da7eca74
-- License: MIT (copyright notice included on the generator source code).
--
create or replace function gen_random_uuid_v7()
returns uuid
as $$
begin
  -- use random v4 uuid as starting point (which has the same variant we need)
  -- then overlay timestamp
  -- then set version 7 by flipping the 2 and 1 bit in the version 4 string
  return encode(
    set_bit(
      set_bit(
        overlay(uuid_send(gen_random_uuid())
                placing substring(int8send(floor(extract(epoch from clock_timestamp()) * 1000)::bigint) from 3)
                from 1 for 6
        ),
        52, 1
      ),
      53, 1
    ),
    'hex')::uuid;
end
$$
language plpgsql
volatile;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "pdf_content" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "description" text NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "schema_definitions" (
    "id" bigserial PRIMARY KEY,
    "properties" json NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "shoebill_template_baseline_implementations" (
    "id" bigserial PRIMARY KEY,
    "stringifiedPayload" text NOT NULL,
    "language" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "baselineId" uuid NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "shoebill_template_baselines" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "referenceLanguage" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "versionId" bigint NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "shoebill_template_scaffolds" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "referencePdfContentId" bigint NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "shoebill_template_version_inputs" (
    "id" bigserial PRIMARY KEY,
    "htmlContent" text NOT NULL,
    "cssContent" text NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "shoebill_template_versions" (
    "id" bigserial PRIMARY KEY,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "schemaId" bigint NOT NULL,
    "inputId" bigint NOT NULL,
    "scaffoldId" uuid NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "template_input_unique_index" ON "shoebill_template_versions" USING btree ("inputId");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "shoebill_template_baseline_implementations"
    ADD CONSTRAINT "shoebill_template_baseline_implementations_fk_0"
    FOREIGN KEY("baselineId")
    REFERENCES "shoebill_template_baselines"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "shoebill_template_baselines"
    ADD CONSTRAINT "shoebill_template_baselines_fk_0"
    FOREIGN KEY("versionId")
    REFERENCES "shoebill_template_versions"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "shoebill_template_scaffolds"
    ADD CONSTRAINT "shoebill_template_scaffolds_fk_0"
    FOREIGN KEY("referencePdfContentId")
    REFERENCES "pdf_content"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "shoebill_template_versions"
    ADD CONSTRAINT "shoebill_template_versions_fk_0"
    FOREIGN KEY("schemaId")
    REFERENCES "schema_definitions"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "shoebill_template_versions"
    ADD CONSTRAINT "shoebill_template_versions_fk_1"
    FOREIGN KEY("inputId")
    REFERENCES "shoebill_template_version_inputs"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "shoebill_template_versions"
    ADD CONSTRAINT "shoebill_template_versions_fk_2"
    FOREIGN KEY("scaffoldId")
    REFERENCES "shoebill_template_scaffolds"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR shoebill_template
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('shoebill_template', '20260123131958365', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260123131958365', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20251208110333922-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251208110333922-v3-0-0', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20251208110420531-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251208110420531-v3-0-0', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20251208110412389-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251208110412389-v3-0-0', "timestamp" = now();


COMMIT;
