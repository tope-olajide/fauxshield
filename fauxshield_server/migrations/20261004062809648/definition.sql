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
-- Class ApiKey as table api_key
--
CREATE TABLE "api_key" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "workspaceId" uuid NOT NULL,
    "label" text NOT NULL,
    "keyHash" text,
    "keyPrefix" text NOT NULL,
    "scopes" json NOT NULL,
    "rateLimitPerMinute" bigint NOT NULL DEFAULT 120,
    "lastUsedAt" timestamp without time zone,
    "revoked" boolean NOT NULL DEFAULT false,
    "createdBy" text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "revokedAt" timestamp without time zone
);

-- Indexes
CREATE INDEX "api_key_workspace_idx" ON "api_key" USING btree ("workspaceId");
CREATE INDEX "api_key_prefix_idx" ON "api_key" USING btree ("keyPrefix");

--
-- Class AttackSimulation as table attack_simulation
--
CREATE TABLE "attack_simulation" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "workspaceId" uuid NOT NULL,
    "type" text NOT NULL,
    "status" text NOT NULL DEFAULT 'queued'::text,
    "label" text,
    "paramsJson" text,
    "progress" bigint NOT NULL DEFAULT 0,
    "totalSteps" bigint NOT NULL DEFAULT 0,
    "summaryJson" text,
    "createdBy" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "startedAt" timestamp without time zone,
    "completedAt" timestamp without time zone,
    "cancelledAt" timestamp without time zone
);

-- Indexes
CREATE INDEX "attack_simulation_workspace_idx" ON "attack_simulation" USING btree ("workspaceId");

--
-- Class AuditEvent as table audit_event
--
CREATE TABLE "audit_event" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "workspaceId" uuid NOT NULL,
    "actorType" text NOT NULL DEFAULT 'system'::text,
    "actorIdentifier" text,
    "apiKeyId" uuid,
    "action" text NOT NULL,
    "targetType" text NOT NULL,
    "targetId" uuid,
    "metadataJson" text,
    "ipAddress" text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "audit_event_workspace_idx" ON "audit_event" USING btree ("workspaceId");
CREATE INDEX "audit_event_action_idx" ON "audit_event" USING btree ("action");

--
-- Class Batch as table batch
--
CREATE TABLE "batch" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "workspaceId" uuid NOT NULL,
    "productId" uuid NOT NULL,
    "reference" text NOT NULL,
    "manufactureDate" timestamp without time zone NOT NULL,
    "expiryDate" timestamp without time zone,
    "distributionRegion" text NOT NULL,
    "quantity" bigint NOT NULL,
    "status" text NOT NULL DEFAULT 'created'::text,
    "notes" text,
    "recallReason" text,
    "recalledAt" timestamp without time zone,
    "recalledBy" text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "batch_workspace_idx" ON "batch" USING btree ("workspaceId");
CREATE INDEX "batch_product_idx" ON "batch" USING btree ("productId");

--
-- Class DailyWorkspaceStat as table daily_workspace_stat
--
CREATE TABLE "daily_workspace_stat" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "workspaceId" uuid NOT NULL,
    "date" timestamp without time zone NOT NULL,
    "verifications" bigint NOT NULL DEFAULT 0,
    "authentic" bigint NOT NULL DEFAULT 0,
    "alreadyVerified" bigint NOT NULL DEFAULT 0,
    "invalidPin" bigint NOT NULL DEFAULT 0,
    "fraudSuspected" bigint NOT NULL DEFAULT 0,
    "highRisk" bigint NOT NULL DEFAULT 0,
    "recalled" bigint NOT NULL DEFAULT 0,
    "alertsCreated" bigint NOT NULL DEFAULT 0,
    "alertsResolved" bigint NOT NULL DEFAULT 0,
    "topCountriesJson" text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "daily_workspace_stat_key_idx" ON "daily_workspace_stat" USING btree ("workspaceId", "date");

--
-- Class FakeReport as table fake_report
--
CREATE TABLE "fake_report" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "workspaceId" uuid NOT NULL,
    "identityId" uuid NOT NULL,
    "sessionId" uuid,
    "reason" text NOT NULL,
    "comment" text,
    "photoStorageId" text,
    "photoPath" text,
    "deviceFingerprint" text,
    "country" text,
    "city" text,
    "status" text NOT NULL DEFAULT 'open'::text,
    "source" text NOT NULL DEFAULT 'consumerWeb'::text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "triagedAt" timestamp without time zone,
    "triagedBy" text
);

-- Indexes
CREATE INDEX "fake_report_workspace_idx" ON "fake_report" USING btree ("workspaceId");
CREATE INDEX "fake_report_identity_idx" ON "fake_report" USING btree ("identityId");

--
-- Class FraudAlert as table fraud_alert
--
CREATE TABLE "fraud_alert" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "workspaceId" uuid NOT NULL,
    "identityId" uuid,
    "batchId" uuid,
    "sessionId" uuid,
    "severity" text NOT NULL,
    "status" text NOT NULL DEFAULT 'open'::text,
    "title" text NOT NULL,
    "description" text NOT NULL,
    "recommendedAction" text,
    "signalTypes" json,
    "dedupeKey" text NOT NULL,
    "autoLocked" boolean NOT NULL DEFAULT false,
    "assignee" text,
    "simulationId" uuid,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "acknowledgedAt" timestamp without time zone,
    "resolvedAt" timestamp without time zone,
    "resolvedBy" text,
    "resolutionNote" text
);

-- Indexes
CREATE UNIQUE INDEX "fraud_alert__dedupeKey__unique_idx" ON "fraud_alert" USING btree ("dedupeKey");
CREATE INDEX "fraud_alert_workspace_idx" ON "fraud_alert" USING btree ("workspaceId");
CREATE INDEX "fraud_alert_status_idx" ON "fraud_alert" USING btree ("status");

--
-- Class FraudSignalRecord as table fraud_signal_record
--
CREATE TABLE "fraud_signal_record" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "workspaceId" uuid NOT NULL,
    "sessionId" uuid NOT NULL,
    "identityId" uuid NOT NULL,
    "batchId" uuid NOT NULL,
    "type" text NOT NULL,
    "severity" text NOT NULL,
    "dataJson" text NOT NULL DEFAULT '{}'::text,
    "detectedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "fraud_signal_record_session_idx" ON "fraud_signal_record" USING btree ("sessionId");
CREATE INDEX "fraud_signal_record_batch_idx" ON "fraud_signal_record" USING btree ("batchId");
CREATE INDEX "fraud_signal_record_workspace_idx" ON "fraud_signal_record" USING btree ("workspaceId");

--
-- Class IdempotencyRecord as table idempotency_record
--
CREATE TABLE "idempotency_record" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "workspaceId" uuid NOT NULL,
    "idempotencyKey" text NOT NULL,
    "operation" text NOT NULL,
    "requestHash" text NOT NULL,
    "responseJson" text,
    "statusCode" bigint,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "expiresAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "idempotency_record__idempotencyKey__unique_idx" ON "idempotency_record" USING btree ("idempotencyKey");
CREATE INDEX "idempotency_record_workspace_idx" ON "idempotency_record" USING btree ("workspaceId");

--
-- Class Invitation as table invitation
--
CREATE TABLE "invitation" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "workspaceId" uuid NOT NULL,
    "email" text NOT NULL,
    "role" text NOT NULL DEFAULT 'member'::text,
    "codeHash" text,
    "codePrefix" text NOT NULL,
    "status" text NOT NULL DEFAULT 'pending'::text,
    "invitedBy" text NOT NULL,
    "expiresAt" timestamp without time zone NOT NULL,
    "acceptedAt" timestamp without time zone,
    "acceptedBy" text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "invitation_code_prefix_idx" ON "invitation" USING btree ("codePrefix");

--
-- Class Notification as table notification
--
CREATE TABLE "notification" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "workspaceId" uuid NOT NULL,
    "userIdentifier" text NOT NULL,
    "type" text NOT NULL,
    "title" text NOT NULL,
    "body" text NOT NULL,
    "targetType" text,
    "targetId" uuid,
    "read" boolean NOT NULL DEFAULT false,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "notification_recipient_idx" ON "notification" USING btree ("userIdentifier");
CREATE INDEX "notification_workspace_idx" ON "notification" USING btree ("workspaceId");

--
-- Class NotificationPreference as table notification_preference
--
CREATE TABLE "notification_preference" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "workspaceId" uuid NOT NULL,
    "userIdentifier" text NOT NULL,
    "channel" text NOT NULL,
    "enabled" boolean NOT NULL DEFAULT true,
    "minSeverity" text NOT NULL DEFAULT 'low'::text,
    "email" text,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "notification_preference_unique_idx" ON "notification_preference" USING btree ("workspaceId", "userIdentifier", "channel");

--
-- Class OfflineScanRecord as table offline_scan_record
--
CREATE TABLE "offline_scan_record" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "spaceId" bigint,
    "workspaceId" uuid,
    "deviceId" text NOT NULL,
    "deviceFingerprint" text,
    "identityId" uuid,
    "qrToken" text NOT NULL,
    "scannedAt" timestamp without time zone NOT NULL,
    "latitude" double precision,
    "longitude" double precision,
    "country" text,
    "city" text,
    "provisionalOutcome" text,
    "processed" boolean NOT NULL DEFAULT false,
    "processedAt" timestamp without time zone,
    "verdictJson" text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "offline_scan_processed_idx" ON "offline_scan_record" USING btree ("processed");

--
-- Class Product as table product
--
CREATE TABLE "product" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "workspaceId" uuid NOT NULL,
    "name" text NOT NULL,
    "sku" text,
    "category" text,
    "description" text,
    "imageUrls" json,
    "packaging" text,
    "shelfLife" text,
    "countryRestrictions" json,
    "safetyInstructions" text,
    "createdBy" text,
    "archivedAt" timestamp without time zone,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "product_workspace_idx" ON "product" USING btree ("workspaceId");

--
-- Class ProductIdentity as table product_identity
--
CREATE TABLE "product_identity" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "workspaceId" uuid NOT NULL,
    "batchId" uuid NOT NULL,
    "qrToken" text NOT NULL,
    "hmacSignature" text NOT NULL,
    "pinHash" text,
    "pinCiphertext" text,
    "status" text NOT NULL DEFAULT 'active'::text,
    "failedPinAttempts" bigint NOT NULL DEFAULT 0,
    "lockedUntil" timestamp without time zone,
    "firstVerified" boolean NOT NULL DEFAULT false,
    "verificationCount" bigint NOT NULL DEFAULT 0,
    "firstVerifiedAt" timestamp without time zone,
    "lastVerifiedAt" timestamp without time zone,
    "recallReason" text,
    "recalledAt" timestamp without time zone,
    "regeneratedFromId" uuid,
    "deletedAt" timestamp without time zone,
    "deletedBy" text,
    "deleteReason" text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "product_identity__qrToken__unique_idx" ON "product_identity" USING btree ("qrToken");
CREATE INDEX "product_identity_workspace_idx" ON "product_identity" USING btree ("workspaceId");
CREATE INDEX "product_identity_batch_idx" ON "product_identity" USING btree ("batchId");

--
-- Class RecallRecord as table recall_record
--
CREATE TABLE "recall_record" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "workspaceId" uuid NOT NULL,
    "batchId" uuid NOT NULL,
    "identityId" uuid,
    "scope" text NOT NULL,
    "reason" text NOT NULL,
    "issuedBy" text NOT NULL,
    "issuedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "lifted" boolean NOT NULL DEFAULT false,
    "liftedAt" timestamp without time zone,
    "liftedBy" text,
    "notes" text
);

-- Indexes
CREATE INDEX "recall_record_workspace_idx" ON "recall_record" USING btree ("workspaceId");
CREATE INDEX "recall_record_batch_idx" ON "recall_record" USING btree ("batchId");

--
-- Class VerificationSession as table verification_session
--
CREATE TABLE "verification_session" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "workspaceId" uuid NOT NULL,
    "identityId" uuid NOT NULL,
    "qrToken" text NOT NULL,
    "deviceFingerprint" text,
    "ipAddress" text,
    "country" text,
    "countryCode" text,
    "city" text,
    "latitude" double precision,
    "longitude" double precision,
    "state" text NOT NULL DEFAULT 'tokenResolved'::text,
    "outcome" text,
    "riskScore" text,
    "source" text NOT NULL DEFAULT 'consumerWeb'::text,
    "offlineScanId" uuid,
    "simulationId" uuid,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "lastStateChange" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "expiresAt" timestamp without time zone NOT NULL,
    "completedAt" timestamp without time zone
);

-- Indexes
CREATE INDEX "verification_session_identity_idx" ON "verification_session" USING btree ("identityId");
CREATE INDEX "verification_session_workspace_idx" ON "verification_session" USING btree ("workspaceId");
CREATE INDEX "verification_session_token_idx" ON "verification_session" USING btree ("qrToken");

--
-- Class WebhookDelivery as table webhook_delivery
--
CREATE TABLE "webhook_delivery" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "workspaceId" uuid NOT NULL,
    "endpointId" uuid NOT NULL,
    "eventType" text NOT NULL,
    "payloadJson" text NOT NULL,
    "status" text NOT NULL DEFAULT 'pending'::text,
    "attemptCount" bigint NOT NULL DEFAULT 0,
    "maxAttempts" bigint NOT NULL DEFAULT 5,
    "lastAttemptAt" timestamp without time zone,
    "nextAttemptAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "lastHttpStatus" bigint,
    "lastError" text,
    "responseTimeMs" bigint,
    "processingStartedAt" timestamp without time zone,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deliveredAt" timestamp without time zone
);

-- Indexes
CREATE INDEX "webhook_delivery_endpoint_idx" ON "webhook_delivery" USING btree ("endpointId");
CREATE INDEX "webhook_delivery_workspace_idx" ON "webhook_delivery" USING btree ("workspaceId");
CREATE INDEX "webhook_delivery_status_idx" ON "webhook_delivery" USING btree ("status");

--
-- Class WebhookEndpoint as table webhook_endpoint
--
CREATE TABLE "webhook_endpoint" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "workspaceId" uuid NOT NULL,
    "url" text NOT NULL,
    "description" text,
    "subscribedEvents" json NOT NULL,
    "enabled" boolean NOT NULL DEFAULT true,
    "consecutiveFailures" bigint NOT NULL DEFAULT 0,
    "encryptedSecret" text,
    "previousEncryptedSecret" text,
    "secretRotatedAt" timestamp without time zone,
    "deletedAt" timestamp without time zone,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "webhook_endpoint_workspace_idx" ON "webhook_endpoint" USING btree ("workspaceId");

--
-- Class Workspace as table workspace
--
CREATE TABLE "workspace" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "name" text NOT NULL,
    "slug" text NOT NULL,
    "branding" json,
    "authenticMessage" text,
    "restrictedCountries" json,
    "fraudPolicy" json,
    "demoMode" boolean NOT NULL DEFAULT false,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "workspace_slug_unique_idx" ON "workspace" USING btree ("slug");

--
-- Class WorkspaceMember as table workspace_member
--
CREATE TABLE "workspace_member" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "workspaceId" uuid NOT NULL,
    "userIdentifier" text NOT NULL,
    "email" text NOT NULL,
    "displayName" text,
    "role" text NOT NULL DEFAULT 'member'::text,
    "notificationEmail" text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "workspace_member__workspaceId__userIdentifier__unique_idx" ON "workspace_member" USING btree ("workspaceId", "userIdentifier");
CREATE INDEX "workspace_member_workspace_idx" ON "workspace_member" USING btree ("workspaceId");

--
-- Class CloudStorageEntry as table serverpod_cloud_storage
--
CREATE TABLE "serverpod_cloud_storage" (
    "id" bigserial PRIMARY KEY,
    "storageId" text NOT NULL,
    "path" text NOT NULL,
    "addedTime" timestamp without time zone NOT NULL,
    "expiration" timestamp without time zone,
    "byteData" bytea NOT NULL,
    "verified" boolean NOT NULL,
    "contentType" text,
    "cacheControl" text,
    "contentDisposition" text,
    "contentEncoding" text,
    "customMetadata" text
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_cloud_storage_path_idx" ON "serverpod_cloud_storage" USING btree ("storageId", "path");
CREATE INDEX "serverpod_cloud_storage_expiration" ON "serverpod_cloud_storage" USING btree ("expiration");

--
-- Class CloudStorageDirectDownloadEntry as table serverpod_cloud_storage_direct_download
--
CREATE TABLE "serverpod_cloud_storage_direct_download" (
    "id" bigserial PRIMARY KEY,
    "storageId" text NOT NULL,
    "path" text NOT NULL,
    "expiration" timestamp without time zone NOT NULL,
    "authKey" text NOT NULL,
    "downloadFileName" text,
    "contentType" text
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_cloud_storage_direct_download_auth_key" ON "serverpod_cloud_storage_direct_download" USING btree ("authKey");
CREATE INDEX "serverpod_cloud_storage_direct_download_expiration" ON "serverpod_cloud_storage_direct_download" USING btree ("expiration");

--
-- Class CloudStorageDirectUploadEntry as table serverpod_cloud_storage_direct_upload
--
CREATE TABLE "serverpod_cloud_storage_direct_upload" (
    "id" bigserial PRIMARY KEY,
    "storageId" text NOT NULL,
    "path" text NOT NULL,
    "expiration" timestamp without time zone NOT NULL,
    "authKey" text NOT NULL,
    "maxFileSize" bigint NOT NULL DEFAULT 10485760,
    "contentLength" bigint,
    "preventOverwrite" boolean NOT NULL DEFAULT false,
    "contentType" text,
    "cacheControl" text,
    "contentDisposition" text,
    "contentEncoding" text,
    "customMetadata" text
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_cloud_storage_direct_upload_storage_path" ON "serverpod_cloud_storage_direct_upload" USING btree ("storageId", "path");

--
-- Class FutureCallEntry as table serverpod_future_call
--
CREATE TABLE "serverpod_future_call" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "time" timestamp without time zone NOT NULL,
    "serializedObject" text,
    "serverId" text NOT NULL,
    "identifier" text,
    "scheduling" json
);

-- Indexes
CREATE INDEX "serverpod_future_call_time_idx" ON "serverpod_future_call" USING btree ("time");
CREATE INDEX "serverpod_future_call_serverId_idx" ON "serverpod_future_call" USING btree ("serverId");
CREATE INDEX "serverpod_future_call_identifier_idx" ON "serverpod_future_call" USING btree ("identifier");

--
-- Class FutureCallClaimEntry as table serverpod_future_call_claim
--
CREATE TABLE "serverpod_future_call_claim" (
    "id" bigserial PRIMARY KEY,
    "futureCallId" bigint,
    "lastHeartbeatTime" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "future_call_unique_idx" ON "serverpod_future_call_claim" USING btree ("futureCallId");

--
-- Class ServerHealthConnectionInfo as table serverpod_health_connection_info
--
CREATE TABLE "serverpod_health_connection_info" (
    "id" bigserial PRIMARY KEY,
    "serverId" text NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    "active" bigint NOT NULL,
    "closing" bigint NOT NULL,
    "idle" bigint NOT NULL,
    "granularity" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_health_connection_info_timestamp_idx" ON "serverpod_health_connection_info" USING btree ("timestamp", "serverId", "granularity");

--
-- Class ServerHealthMetric as table serverpod_health_metric
--
CREATE TABLE "serverpod_health_metric" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "serverId" text NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    "isHealthy" boolean NOT NULL,
    "value" double precision NOT NULL,
    "granularity" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_health_metric_timestamp_idx" ON "serverpod_health_metric" USING btree ("timestamp", "serverId", "name", "granularity");

--
-- Class LogEntry as table serverpod_log
--
CREATE TABLE "serverpod_log" (
    "id" bigserial PRIMARY KEY,
    "sessionLogId" bigint NOT NULL,
    "messageId" bigint,
    "reference" text,
    "serverId" text NOT NULL,
    "time" timestamp without time zone NOT NULL,
    "logLevel" bigint NOT NULL,
    "message" text NOT NULL,
    "error" text,
    "stackTrace" text,
    "order" bigint NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_log_sessionLogId_idx" ON "serverpod_log" USING btree ("sessionLogId", "order");

--
-- Class MessageLogEntry as table serverpod_message_log
--
CREATE TABLE "serverpod_message_log" (
    "id" bigserial PRIMARY KEY,
    "sessionLogId" bigint NOT NULL,
    "serverId" text NOT NULL,
    "messageId" bigint NOT NULL,
    "endpoint" text NOT NULL,
    "messageName" text NOT NULL,
    "duration" double precision NOT NULL,
    "error" text,
    "stackTrace" text,
    "slow" boolean NOT NULL,
    "order" bigint NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_message_log_sessionLogId_idx" ON "serverpod_message_log" USING btree ("sessionLogId", "order");

--
-- Class MethodInfo as table serverpod_method
--
CREATE TABLE "serverpod_method" (
    "id" bigserial PRIMARY KEY,
    "endpoint" text NOT NULL,
    "method" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_method_endpoint_method_idx" ON "serverpod_method" USING btree ("endpoint", "method");

--
-- Class DatabaseMigrationVersion as table serverpod_migrations
--
CREATE TABLE "serverpod_migrations" (
    "id" bigserial PRIMARY KEY,
    "module" text NOT NULL,
    "version" text NOT NULL,
    "timestamp" timestamp without time zone
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_migrations_ids" ON "serverpod_migrations" USING btree ("module");

--
-- Class QueryLogEntry as table serverpod_query_log
--
CREATE TABLE "serverpod_query_log" (
    "id" bigserial PRIMARY KEY,
    "serverId" text NOT NULL,
    "sessionLogId" bigint NOT NULL,
    "messageId" bigint,
    "query" text NOT NULL,
    "duration" double precision NOT NULL,
    "numRows" bigint,
    "error" text,
    "stackTrace" text,
    "slow" boolean NOT NULL,
    "order" bigint NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_query_log_sessionLogId_idx" ON "serverpod_query_log" USING btree ("sessionLogId", "order");

--
-- Class ReadWriteTestEntry as table serverpod_readwrite_test
--
CREATE TABLE "serverpod_readwrite_test" (
    "id" bigserial PRIMARY KEY,
    "number" bigint NOT NULL
);

--
-- Class RuntimeSettings as table serverpod_runtime_settings
--
CREATE TABLE "serverpod_runtime_settings" (
    "id" bigserial PRIMARY KEY,
    "logSettings" json NOT NULL,
    "logSettingsOverrides" json NOT NULL,
    "logServiceCalls" boolean NOT NULL,
    "logMalformedCalls" boolean NOT NULL
);

--
-- Class SessionLogEntry as table serverpod_session_log
--
CREATE TABLE "serverpod_session_log" (
    "id" bigserial PRIMARY KEY,
    "serverId" text NOT NULL,
    "time" timestamp without time zone NOT NULL,
    "module" text,
    "endpoint" text,
    "method" text,
    "duration" double precision,
    "numQueries" bigint,
    "slow" boolean,
    "error" text,
    "stackTrace" text,
    "authenticatedUserId" bigint,
    "userId" text,
    "isOpen" boolean,
    "touched" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_session_log_serverid_idx" ON "serverpod_session_log" USING btree ("serverId");
CREATE INDEX "serverpod_session_log_time_idx" ON "serverpod_session_log" USING btree ("time");
CREATE INDEX "serverpod_session_log_touched_idx" ON "serverpod_session_log" USING btree ("touched");
CREATE INDEX "serverpod_session_log_isopen_idx" ON "serverpod_session_log" USING btree ("isOpen");

--
-- Class AnonymousAccount as table serverpod_auth_idp_anonymous_account
--
CREATE TABLE "serverpod_auth_idp_anonymous_account" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

--
-- Class AppleAccount as table serverpod_auth_idp_apple_account
--
CREATE TABLE "serverpod_auth_idp_apple_account" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "userIdentifier" text NOT NULL,
    "refreshToken" text NOT NULL,
    "refreshTokenRequestedWithBundleIdentifier" boolean NOT NULL,
    "lastRefreshedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "authUserId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "email" text,
    "isEmailVerified" boolean,
    "isPrivateEmail" boolean,
    "firstName" text,
    "lastName" text
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_apple_account_identifier" ON "serverpod_auth_idp_apple_account" USING btree ("userIdentifier");

--
-- Class EmailAccount as table serverpod_auth_idp_email_account
--
CREATE TABLE "serverpod_auth_idp_email_account" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "email" text NOT NULL,
    "passwordHash" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_idp_email_account_email" ON "serverpod_auth_idp_email_account" USING btree ("email");

--
-- Class EmailAccountPasswordResetRequest as table serverpod_auth_idp_email_account_password_reset_request
--
CREATE TABLE "serverpod_auth_idp_email_account_password_reset_request" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "emailAccountId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "challengeId" uuid NOT NULL,
    "setPasswordChallengeId" uuid
);

--
-- Class EmailAccountRequest as table serverpod_auth_idp_email_account_request
--
CREATE TABLE "serverpod_auth_idp_email_account_request" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "email" text NOT NULL,
    "challengeId" uuid NOT NULL,
    "createAccountChallengeId" uuid
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_idp_email_account_request_email" ON "serverpod_auth_idp_email_account_request" USING btree ("email");

--
-- Class FacebookAccount as table serverpod_auth_idp_facebook_account
--
CREATE TABLE "serverpod_auth_idp_facebook_account" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "userIdentifier" text NOT NULL,
    "email" text,
    "fullName" text,
    "firstName" text,
    "lastName" text
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_facebook_account_user_identifier" ON "serverpod_auth_idp_facebook_account" USING btree ("userIdentifier");

--
-- Class FirebaseAccount as table serverpod_auth_idp_firebase_account
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
-- Class GitHubAccount as table serverpod_auth_idp_github_account
--
CREATE TABLE "serverpod_auth_idp_github_account" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "userIdentifier" text NOT NULL,
    "email" text,
    "created" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_github_account_user_identifier" ON "serverpod_auth_idp_github_account" USING btree ("userIdentifier");

--
-- Class GoogleAccount as table serverpod_auth_idp_google_account
--
CREATE TABLE "serverpod_auth_idp_google_account" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "created" timestamp without time zone NOT NULL,
    "email" text NOT NULL,
    "userIdentifier" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_google_account_user_identifier" ON "serverpod_auth_idp_google_account" USING btree ("userIdentifier");

--
-- Class MicrosoftAccount as table serverpod_auth_idp_microsoft_account
--
CREATE TABLE "serverpod_auth_idp_microsoft_account" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "userIdentifier" text NOT NULL,
    "email" text,
    "created" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_microsoft_account_user_identifier" ON "serverpod_auth_idp_microsoft_account" USING btree ("userIdentifier");

--
-- Class PasskeyAccount as table serverpod_auth_idp_passkey_account
--
CREATE TABLE "serverpod_auth_idp_passkey_account" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "keyId" bytea NOT NULL,
    "keyIdBase64" text NOT NULL,
    "clientDataJSON" bytea NOT NULL,
    "attestationObject" bytea NOT NULL,
    "originalChallenge" bytea NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_idp_passkey_account_key_id_base64" ON "serverpod_auth_idp_passkey_account" USING btree ("keyIdBase64");

--
-- Class PasskeyChallenge as table serverpod_auth_idp_passkey_challenge
--
CREATE TABLE "serverpod_auth_idp_passkey_challenge" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "createdAt" timestamp without time zone NOT NULL,
    "challenge" bytea NOT NULL
);

--
-- Class RateLimitedRequestAttempt as table serverpod_auth_idp_rate_limited_request_attempt
--
CREATE TABLE "serverpod_auth_idp_rate_limited_request_attempt" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "domain" text NOT NULL,
    "source" text NOT NULL,
    "key" text NOT NULL,
    "ipAddress" text,
    "attemptedAt" timestamp without time zone NOT NULL,
    "extraData" json
);

-- Indexes
CREATE INDEX "serverpod_auth_idp_rate_limited_request_attempt_composite" ON "serverpod_auth_idp_rate_limited_request_attempt" USING btree ("domain", "source", "key", "attemptedAt");

--
-- Class SecretChallenge as table serverpod_auth_idp_secret_challenge
--
CREATE TABLE "serverpod_auth_idp_secret_challenge" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "challengeCodeHash" text NOT NULL
);

--
-- Class CrdtDataAttemptedValue as table crdt_data_attempted_value
--
CREATE TABLE "crdt_data_attempted_value" (
    "id" bigserial PRIMARY KEY,
    "fieldId" bigint NOT NULL,
    "value" jsonb NOT NULL,
    "projectionReason" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "crdt_data_attempted_value__fieldId__unique_idx" ON "crdt_data_attempted_value" USING btree ("fieldId");

--
-- Class CrdtDataField as table crdt_data_fields
--
CREATE TABLE "crdt_data_fields" (
    "id" bigserial PRIMARY KEY,
    "hlcDatetime" timestamp without time zone NOT NULL,
    "hlcCounter" bigint NOT NULL,
    "rowId" bigint NOT NULL,
    "columnId" bigint NOT NULL,
    "nodeId" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "crdt_data_fields_row_column_idx" ON "crdt_data_fields" USING btree ("rowId", "columnId");

--
-- Class CrdtDataRow as table crdt_data_rows
--
CREATE TABLE "crdt_data_rows" (
    "id" bigserial PRIMARY KEY,
    "hlcDatetime" timestamp without time zone NOT NULL,
    "hlcCounter" bigint NOT NULL,
    "spaceId" bigint NOT NULL,
    "tblId" bigint NOT NULL,
    "uuidRowId" uuid NOT NULL,
    "nodeId" bigint NOT NULL,
    "visibility" bigint NOT NULL DEFAULT 0
);

-- Indexes
CREATE UNIQUE INDEX "crdt_data_rows_space_tbl_row_idx" ON "crdt_data_rows" USING btree ("spaceId", "tblId", "uuidRowId");

--
-- Class CrdtDataDeleted as table crdt_data_tombstone
--
CREATE TABLE "crdt_data_tombstone" (
    "id" bigserial PRIMARY KEY,
    "hlcDatetime" timestamp without time zone NOT NULL,
    "hlcCounter" bigint NOT NULL,
    "rowId" bigint NOT NULL,
    "nodeId" bigint NOT NULL,
    "clFlag" bigint NOT NULL,
    "reason" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "crdt_data_tombstone_row_idx" ON "crdt_data_tombstone" USING btree ("rowId");

--
-- Class CrdtNode as table crdt_nodes
--
CREATE TABLE "crdt_nodes" (
    "id" bigserial PRIMARY KEY,
    "uuidNodeId" uuid NOT NULL DEFAULT gen_random_uuid_v7(),
    "lastHlc" jsonb
);

-- Indexes
CREATE UNIQUE INDEX "crdt_nodes__uuidNodeId__unique_idx" ON "crdt_nodes" USING btree ("uuidNodeId");

--
-- Class CrdtSchemaColumn as table crdt_schema_columns
--
CREATE TABLE "crdt_schema_columns" (
    "id" bigserial PRIMARY KEY,
    "tblId" bigint NOT NULL,
    "name" text NOT NULL,
    "columnType" text NOT NULL,
    "dartType" text NOT NULL,
    "isNullable" boolean NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "crdt_schema_columns_table_column_idx" ON "crdt_schema_columns" USING btree ("tblId", "name");

--
-- Class CrdtSchemaTable as table crdt_schema_tables
--
CREATE TABLE "crdt_schema_tables" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "crdt_schema_tables__name__unique_idx" ON "crdt_schema_tables" USING btree ("name");

--
-- Class OfflineSyncIntegrityViolation as table offline_sync_integrity_violations
--
CREATE TABLE "offline_sync_integrity_violations" (
    "id" bigserial PRIMARY KEY,
    "type" text NOT NULL,
    "domainTableName" text NOT NULL,
    "uuidRowId" uuid NOT NULL,
    "ownerSpaceUuid" uuid,
    "incomingSpaceUuid" uuid NOT NULL,
    "operation" text NOT NULL,
    "uuidNodeId" uuid,
    "crdtDataRowId" bigint,
    "hlcDatetime" timestamp without time zone,
    "hlcCounter" bigint,
    "firstSeenAt" timestamp without time zone NOT NULL,
    "lastSeenAt" timestamp without time zone NOT NULL,
    "occurrences" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "offline_sync_integrity_violations_key_idx" ON "offline_sync_integrity_violations" USING btree ("type", "operation", "domainTableName", "uuidRowId", "ownerSpaceUuid", "incomingSpaceUuid");

--
-- Class OfflineSyncSpaceMember as table offline_sync_space_members
--
CREATE TABLE "offline_sync_space_members" (
    "id" bigserial PRIMARY KEY,
    "spaceId" bigint NOT NULL,
    "userUuid" uuid NOT NULL,
    "role" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "offline_sync_space_member_unique_idx" ON "offline_sync_space_members" USING btree ("userUuid", "spaceId");

--
-- Class OfflineSyncSpaceNode as table offline_sync_space_nodes
--
CREATE TABLE "offline_sync_space_nodes" (
    "id" bigserial PRIMARY KEY,
    "spaceId" bigint NOT NULL,
    "nodeId" bigint NOT NULL,
    "lastReceivedHlc" jsonb
);

-- Indexes
CREATE UNIQUE INDEX "offline_sync_space_node_unique_idx" ON "offline_sync_space_nodes" USING btree ("spaceId", "nodeId");

--
-- Class OfflineSyncSpace as table offline_sync_spaces
--
CREATE TABLE "offline_sync_spaces" (
    "id" bigserial PRIMARY KEY,
    "uuidSpaceId" uuid NOT NULL DEFAULT gen_random_uuid_v7(),
    "currentNodeId" bigint
);

-- Indexes
CREATE UNIQUE INDEX "offline_sync_spaces__uuidSpaceId__unique_idx" ON "offline_sync_spaces" USING btree ("uuidSpaceId");

--
-- Class RefreshToken as table serverpod_auth_core_jwt_refresh_token
--
CREATE TABLE "serverpod_auth_core_jwt_refresh_token" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "scopeNames" json NOT NULL,
    "extraClaims" text,
    "method" text NOT NULL,
    "fixedSecret" bytea NOT NULL,
    "rotatingSecretHash" text NOT NULL,
    "lastUpdatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "serverpod_auth_core_jwt_refresh_token_last_updated_at" ON "serverpod_auth_core_jwt_refresh_token" USING btree ("lastUpdatedAt");

--
-- Class UserProfile as table serverpod_auth_core_profile
--
CREATE TABLE "serverpod_auth_core_profile" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "userName" text,
    "fullName" text,
    "email" text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "imageId" uuid
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_profile_user_profile_email_auth_user_id" ON "serverpod_auth_core_profile" USING btree ("authUserId");

--
-- Class UserProfileImage as table serverpod_auth_core_profile_image
--
CREATE TABLE "serverpod_auth_core_profile_image" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "userProfileId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "storageId" text NOT NULL,
    "path" text NOT NULL,
    "url" text NOT NULL
);

--
-- Class ServerSideSession as table serverpod_auth_core_session
--
CREATE TABLE "serverpod_auth_core_session" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "scopeNames" json NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "lastUsedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "expiresAt" timestamp without time zone,
    "expireAfterUnusedFor" bigint,
    "sessionKeyHash" bytea NOT NULL,
    "sessionKeySalt" bytea NOT NULL,
    "method" text NOT NULL
);

--
-- Class AuthUser as table serverpod_auth_core_user
--
CREATE TABLE "serverpod_auth_core_user" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "createdAt" timestamp without time zone NOT NULL,
    "scopeNames" json NOT NULL,
    "blocked" boolean NOT NULL
);

--
-- Foreign relations for "api_key" table
--
ALTER TABLE ONLY "api_key"
    ADD CONSTRAINT "api_key_fk_0"
    FOREIGN KEY("workspaceId")
    REFERENCES "workspace"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "attack_simulation" table
--
ALTER TABLE ONLY "attack_simulation"
    ADD CONSTRAINT "attack_simulation_fk_0"
    FOREIGN KEY("workspaceId")
    REFERENCES "workspace"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "audit_event" table
--
ALTER TABLE ONLY "audit_event"
    ADD CONSTRAINT "audit_event_fk_0"
    FOREIGN KEY("workspaceId")
    REFERENCES "workspace"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "batch" table
--
ALTER TABLE ONLY "batch"
    ADD CONSTRAINT "batch_fk_0"
    FOREIGN KEY("workspaceId")
    REFERENCES "workspace"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "batch"
    ADD CONSTRAINT "batch_fk_1"
    FOREIGN KEY("productId")
    REFERENCES "product"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "daily_workspace_stat" table
--
ALTER TABLE ONLY "daily_workspace_stat"
    ADD CONSTRAINT "daily_workspace_stat_fk_0"
    FOREIGN KEY("workspaceId")
    REFERENCES "workspace"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "fake_report" table
--
ALTER TABLE ONLY "fake_report"
    ADD CONSTRAINT "fake_report_fk_0"
    FOREIGN KEY("workspaceId")
    REFERENCES "workspace"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "fake_report"
    ADD CONSTRAINT "fake_report_fk_1"
    FOREIGN KEY("identityId")
    REFERENCES "product_identity"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "fraud_alert" table
--
ALTER TABLE ONLY "fraud_alert"
    ADD CONSTRAINT "fraud_alert_fk_0"
    FOREIGN KEY("workspaceId")
    REFERENCES "workspace"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "fraud_signal_record" table
--
ALTER TABLE ONLY "fraud_signal_record"
    ADD CONSTRAINT "fraud_signal_record_fk_0"
    FOREIGN KEY("workspaceId")
    REFERENCES "workspace"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "fraud_signal_record"
    ADD CONSTRAINT "fraud_signal_record_fk_1"
    FOREIGN KEY("sessionId")
    REFERENCES "verification_session"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "invitation" table
--
ALTER TABLE ONLY "invitation"
    ADD CONSTRAINT "invitation_fk_0"
    FOREIGN KEY("workspaceId")
    REFERENCES "workspace"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "notification" table
--
ALTER TABLE ONLY "notification"
    ADD CONSTRAINT "notification_fk_0"
    FOREIGN KEY("workspaceId")
    REFERENCES "workspace"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "notification_preference" table
--
ALTER TABLE ONLY "notification_preference"
    ADD CONSTRAINT "notification_preference_fk_0"
    FOREIGN KEY("workspaceId")
    REFERENCES "workspace"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "offline_scan_record" table
--
ALTER TABLE ONLY "offline_scan_record"
    ADD CONSTRAINT "offline_scan_record_fk_0"
    FOREIGN KEY("spaceId")
    REFERENCES "offline_sync_spaces"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "product" table
--
ALTER TABLE ONLY "product"
    ADD CONSTRAINT "product_fk_0"
    FOREIGN KEY("workspaceId")
    REFERENCES "workspace"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "product_identity" table
--
ALTER TABLE ONLY "product_identity"
    ADD CONSTRAINT "product_identity_fk_0"
    FOREIGN KEY("workspaceId")
    REFERENCES "workspace"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "product_identity"
    ADD CONSTRAINT "product_identity_fk_1"
    FOREIGN KEY("batchId")
    REFERENCES "batch"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "recall_record" table
--
ALTER TABLE ONLY "recall_record"
    ADD CONSTRAINT "recall_record_fk_0"
    FOREIGN KEY("workspaceId")
    REFERENCES "workspace"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "verification_session" table
--
ALTER TABLE ONLY "verification_session"
    ADD CONSTRAINT "verification_session_fk_0"
    FOREIGN KEY("workspaceId")
    REFERENCES "workspace"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "verification_session"
    ADD CONSTRAINT "verification_session_fk_1"
    FOREIGN KEY("identityId")
    REFERENCES "product_identity"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "webhook_delivery" table
--
ALTER TABLE ONLY "webhook_delivery"
    ADD CONSTRAINT "webhook_delivery_fk_0"
    FOREIGN KEY("endpointId")
    REFERENCES "webhook_endpoint"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "webhook_endpoint" table
--
ALTER TABLE ONLY "webhook_endpoint"
    ADD CONSTRAINT "webhook_endpoint_fk_0"
    FOREIGN KEY("workspaceId")
    REFERENCES "workspace"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "workspace_member" table
--
ALTER TABLE ONLY "workspace_member"
    ADD CONSTRAINT "workspace_member_fk_0"
    FOREIGN KEY("workspaceId")
    REFERENCES "workspace"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_future_call_claim" table
--
ALTER TABLE ONLY "serverpod_future_call_claim"
    ADD CONSTRAINT "serverpod_future_call_claim_fk_0"
    FOREIGN KEY("futureCallId")
    REFERENCES "serverpod_future_call"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_log" table
--
ALTER TABLE ONLY "serverpod_log"
    ADD CONSTRAINT "serverpod_log_fk_0"
    FOREIGN KEY("sessionLogId")
    REFERENCES "serverpod_session_log"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_message_log" table
--
ALTER TABLE ONLY "serverpod_message_log"
    ADD CONSTRAINT "serverpod_message_log_fk_0"
    FOREIGN KEY("sessionLogId")
    REFERENCES "serverpod_session_log"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_query_log" table
--
ALTER TABLE ONLY "serverpod_query_log"
    ADD CONSTRAINT "serverpod_query_log_fk_0"
    FOREIGN KEY("sessionLogId")
    REFERENCES "serverpod_session_log"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_idp_anonymous_account" table
--
ALTER TABLE ONLY "serverpod_auth_idp_anonymous_account"
    ADD CONSTRAINT "serverpod_auth_idp_anonymous_account_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_idp_apple_account" table
--
ALTER TABLE ONLY "serverpod_auth_idp_apple_account"
    ADD CONSTRAINT "serverpod_auth_idp_apple_account_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_idp_email_account" table
--
ALTER TABLE ONLY "serverpod_auth_idp_email_account"
    ADD CONSTRAINT "serverpod_auth_idp_email_account_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_idp_email_account_password_reset_request" table
--
ALTER TABLE ONLY "serverpod_auth_idp_email_account_password_reset_request"
    ADD CONSTRAINT "serverpod_auth_idp_email_account_password_reset_request_fk_0"
    FOREIGN KEY("emailAccountId")
    REFERENCES "serverpod_auth_idp_email_account"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "serverpod_auth_idp_email_account_password_reset_request"
    ADD CONSTRAINT "serverpod_auth_idp_email_account_password_reset_request_fk_1"
    FOREIGN KEY("challengeId")
    REFERENCES "serverpod_auth_idp_secret_challenge"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "serverpod_auth_idp_email_account_password_reset_request"
    ADD CONSTRAINT "serverpod_auth_idp_email_account_password_reset_request_fk_2"
    FOREIGN KEY("setPasswordChallengeId")
    REFERENCES "serverpod_auth_idp_secret_challenge"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_idp_email_account_request" table
--
ALTER TABLE ONLY "serverpod_auth_idp_email_account_request"
    ADD CONSTRAINT "serverpod_auth_idp_email_account_request_fk_0"
    FOREIGN KEY("challengeId")
    REFERENCES "serverpod_auth_idp_secret_challenge"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "serverpod_auth_idp_email_account_request"
    ADD CONSTRAINT "serverpod_auth_idp_email_account_request_fk_1"
    FOREIGN KEY("createAccountChallengeId")
    REFERENCES "serverpod_auth_idp_secret_challenge"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_idp_facebook_account" table
--
ALTER TABLE ONLY "serverpod_auth_idp_facebook_account"
    ADD CONSTRAINT "serverpod_auth_idp_facebook_account_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_idp_firebase_account" table
--
ALTER TABLE ONLY "serverpod_auth_idp_firebase_account"
    ADD CONSTRAINT "serverpod_auth_idp_firebase_account_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_idp_github_account" table
--
ALTER TABLE ONLY "serverpod_auth_idp_github_account"
    ADD CONSTRAINT "serverpod_auth_idp_github_account_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_idp_google_account" table
--
ALTER TABLE ONLY "serverpod_auth_idp_google_account"
    ADD CONSTRAINT "serverpod_auth_idp_google_account_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_idp_microsoft_account" table
--
ALTER TABLE ONLY "serverpod_auth_idp_microsoft_account"
    ADD CONSTRAINT "serverpod_auth_idp_microsoft_account_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_idp_passkey_account" table
--
ALTER TABLE ONLY "serverpod_auth_idp_passkey_account"
    ADD CONSTRAINT "serverpod_auth_idp_passkey_account_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "crdt_data_attempted_value" table
--
ALTER TABLE ONLY "crdt_data_attempted_value"
    ADD CONSTRAINT "crdt_data_attempted_value_fk_0"
    FOREIGN KEY("fieldId")
    REFERENCES "crdt_data_fields"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "crdt_data_fields" table
--
ALTER TABLE ONLY "crdt_data_fields"
    ADD CONSTRAINT "crdt_data_fields_fk_0"
    FOREIGN KEY("rowId")
    REFERENCES "crdt_data_rows"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "crdt_data_fields"
    ADD CONSTRAINT "crdt_data_fields_fk_1"
    FOREIGN KEY("columnId")
    REFERENCES "crdt_schema_columns"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "crdt_data_fields"
    ADD CONSTRAINT "crdt_data_fields_fk_2"
    FOREIGN KEY("nodeId")
    REFERENCES "crdt_nodes"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "crdt_data_rows" table
--
ALTER TABLE ONLY "crdt_data_rows"
    ADD CONSTRAINT "crdt_data_rows_fk_0"
    FOREIGN KEY("spaceId")
    REFERENCES "offline_sync_spaces"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "crdt_data_rows"
    ADD CONSTRAINT "crdt_data_rows_fk_1"
    FOREIGN KEY("tblId")
    REFERENCES "crdt_schema_tables"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "crdt_data_rows"
    ADD CONSTRAINT "crdt_data_rows_fk_2"
    FOREIGN KEY("nodeId")
    REFERENCES "crdt_nodes"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "crdt_data_tombstone" table
--
ALTER TABLE ONLY "crdt_data_tombstone"
    ADD CONSTRAINT "crdt_data_tombstone_fk_0"
    FOREIGN KEY("rowId")
    REFERENCES "crdt_data_rows"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "crdt_data_tombstone"
    ADD CONSTRAINT "crdt_data_tombstone_fk_1"
    FOREIGN KEY("nodeId")
    REFERENCES "crdt_nodes"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "crdt_schema_columns" table
--
ALTER TABLE ONLY "crdt_schema_columns"
    ADD CONSTRAINT "crdt_schema_columns_fk_0"
    FOREIGN KEY("tblId")
    REFERENCES "crdt_schema_tables"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "offline_sync_space_members" table
--
ALTER TABLE ONLY "offline_sync_space_members"
    ADD CONSTRAINT "offline_sync_space_members_fk_0"
    FOREIGN KEY("spaceId")
    REFERENCES "offline_sync_spaces"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "offline_sync_space_nodes" table
--
ALTER TABLE ONLY "offline_sync_space_nodes"
    ADD CONSTRAINT "offline_sync_space_nodes_fk_0"
    FOREIGN KEY("spaceId")
    REFERENCES "offline_sync_spaces"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "offline_sync_space_nodes"
    ADD CONSTRAINT "offline_sync_space_nodes_fk_1"
    FOREIGN KEY("nodeId")
    REFERENCES "crdt_nodes"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "offline_sync_spaces" table
--
ALTER TABLE ONLY "offline_sync_spaces"
    ADD CONSTRAINT "offline_sync_spaces_fk_0"
    FOREIGN KEY("currentNodeId")
    REFERENCES "crdt_nodes"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_core_jwt_refresh_token" table
--
ALTER TABLE ONLY "serverpod_auth_core_jwt_refresh_token"
    ADD CONSTRAINT "serverpod_auth_core_jwt_refresh_token_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_core_profile" table
--
ALTER TABLE ONLY "serverpod_auth_core_profile"
    ADD CONSTRAINT "serverpod_auth_core_profile_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "serverpod_auth_core_profile"
    ADD CONSTRAINT "serverpod_auth_core_profile_fk_1"
    FOREIGN KEY("imageId")
    REFERENCES "serverpod_auth_core_profile_image"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    DEFERRABLE INITIALLY DEFERRED;

--
-- Foreign relations for "serverpod_auth_core_profile_image" table
--
ALTER TABLE ONLY "serverpod_auth_core_profile_image"
    ADD CONSTRAINT "serverpod_auth_core_profile_image_fk_0"
    FOREIGN KEY("userProfileId")
    REFERENCES "serverpod_auth_core_profile"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_core_session" table
--
ALTER TABLE ONLY "serverpod_auth_core_session"
    ADD CONSTRAINT "serverpod_auth_core_session_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR fauxshield
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('fauxshield', '20261004062809648', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261004062809648', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260824182259319', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182259319', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20260924105404509', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260924105404509', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_offline_sync
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_offline_sync', '20260914143806119', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260914143806119', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20260924105232991', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260924105232991', "timestamp" = now();


COMMIT;
