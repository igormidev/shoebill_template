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
CREATE TABLE "account_info" (
    "id" bigserial PRIMARY KEY,
    "authUserId" uuid NOT NULL,
    "email" text NOT NULL,
    "name" text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "auth_user_id_unique_idx" ON "account_info" USING btree ("authUserId");
CREATE UNIQUE INDEX "email_unique_idx" ON "account_info" USING btree ("email");

--
-- ACTION DROP TABLE
--
DROP TABLE "shoebill_template_baseline_implementations" CASCADE;

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
-- ACTION DROP TABLE
--
DROP TABLE "shoebill_template_baselines" CASCADE;

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
-- ACTION ALTER TABLE
--
ALTER TABLE "shoebill_template_scaffolds" ADD COLUMN "accountId" bigint;
--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_auth_idp_firebase_account" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "created" timestamp without time zone NOT NULL,
    "email" text,
    "phone" text,
    "userIdentifier" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_firebase_account_user_identifier" ON "serverpod_auth_idp_firebase_account" USING btree ("userIdentifier");

--
-- ACTION ALTER TABLE
--
DROP INDEX "serverpod_auth_idp_rate_limited_request_attempt_domain";
DROP INDEX "serverpod_auth_idp_rate_limited_request_attempt_source";
DROP INDEX "serverpod_auth_idp_rate_limited_request_attempt_nonce";
CREATE INDEX "serverpod_auth_idp_rate_limited_request_attempt_composite" ON "serverpod_auth_idp_rate_limited_request_attempt" USING btree ("domain", "source", "nonce", "attemptedAt");
--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "account_info"
    ADD CONSTRAINT "account_info_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

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
    ADD CONSTRAINT "shoebill_template_scaffolds_fk_1"
    FOREIGN KEY("accountId")
    REFERENCES "account_info"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "serverpod_auth_idp_firebase_account"
    ADD CONSTRAINT "serverpod_auth_idp_firebase_account_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR shoebill_template
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('shoebill_template', '20260127014729580', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260127014729580', "timestamp" = now();

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
    VALUES ('serverpod_auth_idp', '20260109031533194', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260109031533194', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20251208110412389-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251208110412389-v3-0-0', "timestamp" = now();


COMMIT;
