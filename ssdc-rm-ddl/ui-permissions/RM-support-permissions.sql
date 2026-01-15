BEGIN;

-- RM SUPPORT ACTIONS
INSERT INTO casev3.user_group (id, description, name) VALUES ('a25c7f99-d2ce-4267-aea4-0a133028f793', 'Group to temporarily move into to get all Action permissions except create Users or Groups', 'RM SUPPORT ACTIONS') ON CONFLICT DO NOTHING;

INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('938cee41-3ad7-4740-af07-1501a2931d90', 'EXCEPTION_MANAGER_QUARANTINE', 'a25c7f99-d2ce-4267-aea4-0a133028f793', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('e454c6a4-37b8-48f2-b180-33a6d1dac0db', 'EXCEPTION_MANAGER_PEEK', 'a25c7f99-d2ce-4267-aea4-0a133028f793', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('08be718e-0afd-4320-9cf7-1531e84f69da', 'CREATE_SURVEY', 'a25c7f99-d2ce-4267-aea4-0a133028f793', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('b853b901-8159-40d0-a373-309ff32f8bca', 'CREATE_EXPORT_FILE_TEMPLATE', 'a25c7f99-d2ce-4267-aea4-0a133028f793', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('13c8f54e-9ed1-40e2-a89d-d5714a2b9e46', 'CREATE_SMS_TEMPLATE', 'a25c7f99-d2ce-4267-aea4-0a133028f793', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('bd0a7643-8db3-4b52-ba8c-ff62aa3068fd', 'CREATE_EMAIL_TEMPLATE', 'a25c7f99-d2ce-4267-aea4-0a133028f793', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('3c2cd0bd-9c7d-4802-b01d-a9d62b24d37c', 'CREATE_COLLECTION_EXERCISE', 'a25c7f99-d2ce-4267-aea4-0a133028f793', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('ce7c2e7e-8b0f-483a-b80c-1dbc3e6a91ba', 'ALLOW_EXPORT_FILE_TEMPLATE_ON_ACTION_RULE', 'a25c7f99-d2ce-4267-aea4-0a133028f793', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('0f24d3c2-d625-41f8-b1a6-9f42f4de60a9', 'ALLOW_SMS_TEMPLATE_ON_ACTION_RULE', 'a25c7f99-d2ce-4267-aea4-0a133028f793', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('d57bc0aa-e98b-4f7e-85b5-5c9bcfa284db', 'ALLOW_EMAIL_TEMPLATE_ON_ACTION_RULE', 'a25c7f99-d2ce-4267-aea4-0a133028f793', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('558ec090-d44b-401b-abbb-7352e11aafbe', 'ALLOW_EMAIL_TEMPLATE_ON_FULFILMENT', 'a25c7f99-d2ce-4267-aea4-0a133028f793', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('c6424f68-87a5-417d-9ea1-2969795ee01a', 'CREATE_EXPORT_FILE_ACTION_RULE', 'a25c7f99-d2ce-4267-aea4-0a133028f793', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('b87d94b9-f916-420f-90cc-52705fc415b8', 'CREATE_FACE_TO_FACE_ACTION_RULE', 'a25c7f99-d2ce-4267-aea4-0a133028f793', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('1b5219ca-9e56-4b49-9208-95edc6ead0d3', 'CREATE_OUTBOUND_PHONE_ACTION_RULE', 'a25c7f99-d2ce-4267-aea4-0a133028f793', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('7d9324aa-deb7-4da7-bd38-4c89345a7ecd', 'CREATE_DEACTIVATE_UAC_ACTION_RULE', 'a25c7f99-d2ce-4267-aea4-0a133028f793', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('aa9c83d5-beac-48c3-b32e-9851a057bc83', 'CREATE_EQ_FLUSH_ACTION_RULE', 'a25c7f99-d2ce-4267-aea4-0a133028f793', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('188a309b-c4cb-4e84-9846-aefec2929216', 'CREATE_SMS_ACTION_RULE', 'a25c7f99-d2ce-4267-aea4-0a133028f793', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('825179c4-076d-49c4-81d5-53848b288b48', 'CREATE_EMAIL_ACTION_RULE', 'a25c7f99-d2ce-4267-aea4-0a133028f793', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('54c61071-4c61-4477-8b83-071d7314f943', 'LOAD_SAMPLE', 'a25c7f99-d2ce-4267-aea4-0a133028f793', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('b787fba3-1bf0-4ea4-be66-ed71e235be02', 'LOAD_BULK_REFUSAL', 'a25c7f99-d2ce-4267-aea4-0a133028f793', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('5b34b96b-b813-4cab-af07-ea6e9c3c2d0d', 'LOAD_BULK_UPDATE_SAMPLE_SENSITIVE', 'a25c7f99-d2ce-4267-aea4-0a133028f793', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('6a4dd655-423d-4d56-bc38-604a61e55721', 'LOAD_BULK_INVALID', 'a25c7f99-d2ce-4267-aea4-0a133028f793', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('4b244c4d-d3ca-4841-a396-d03dc200396f', 'LOAD_BULK_UPDATE_SAMPLE', 'a25c7f99-d2ce-4267-aea4-0a133028f793', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('5798a4a2-9ab8-4509-9f88-71fde81e6948', 'DEACTIVATE_UAC', 'a25c7f99-d2ce-4267-aea4-0a133028f793', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('5cfe474a-71f3-46bf-b9fe-fa6388c8c9da', 'CREATE_CASE_REFUSAL', 'a25c7f99-d2ce-4267-aea4-0a133028f793', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('c484fdc8-3bfd-40ad-b608-75b9d94b434e', 'CREATE_CASE_INVALID_CASE', 'a25c7f99-d2ce-4267-aea4-0a133028f793', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('336002f6-b98b-40dc-acf6-6490b6348d8e', 'UPDATE_SAMPLE', 'a25c7f99-d2ce-4267-aea4-0a133028f793', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('20348a51-352f-4f2d-98d3-d6549110b9bf', 'UPDATE_SAMPLE_SENSITIVE', 'a25c7f99-d2ce-4267-aea4-0a133028f793', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('dddfd81d-a184-4c71-a639-df64acf47b37', 'CREATE_CASE_EXPORT_FILE_FULFILMENT', 'a25c7f99-d2ce-4267-aea4-0a133028f793', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('ccc4e85f-ecb9-467d-be11-715ab605cf02', 'CREATE_CASE_SMS_FULFILMENT', 'a25c7f99-d2ce-4267-aea4-0a133028f793', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('4990e4de-42aa-4fd7-a654-554e440def38', 'CREATE_CASE_EMAIL_FULFILMENT', 'a25c7f99-d2ce-4267-aea4-0a133028f793', NULL) ON CONFLICT DO NOTHING;

-- RM SUPPORT
INSERT INTO casev3.user_group VALUES ('b19a77bd-6a02-4851-8116-9e915738b700', 'RM Support - Read only', 'RM SUPPORT') ON CONFLICT DO NOTHING;

INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('6f655e60-be27-4092-84e0-3b64971a4dac', 'EXCEPTION_MANAGER_VIEWER', 'b19a77bd-6a02-4851-8116-9e915738b700', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('81e78da1-5e2a-4457-a2ee-cc12c884f2fa', 'LIST_ACTION_RULES', 'b19a77bd-6a02-4851-8116-9e915738b700', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('ff682c9f-11db-42be-9e22-b384cf96557e', 'LIST_ALLOWED_EMAIL_TEMPLATES_ON_ACTION_RULES', 'b19a77bd-6a02-4851-8116-9e915738b700', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('db5e3d2b-0bb1-4fcd-a99b-0f90a319ba04', 'LIST_ALLOWED_EMAIL_TEMPLATES_ON_FULFILMENTS', 'b19a77bd-6a02-4851-8116-9e915738b700', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('0fefc7ac-3548-49a8-8f5c-512b1e319ecc', 'LIST_ALLOWED_EXPORT_FILE_TEMPLATES_ON_ACTION_RULES', 'b19a77bd-6a02-4851-8116-9e915738b700', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('900abc3c-ee97-4101-81ca-09f753651109', 'LIST_ALLOWED_EXPORT_FILE_TEMPLATES_ON_FULFILMENTS', 'b19a77bd-6a02-4851-8116-9e915738b700', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('191408ca-7579-4135-a070-c5c9c3907b51', 'LIST_ALLOWED_SMS_TEMPLATES_ON_ACTION_RULES', 'b19a77bd-6a02-4851-8116-9e915738b700', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('7ebd8b21-e90d-4c76-b98c-984146137507', 'LIST_ALLOWED_SMS_TEMPLATES_ON_FULFILMENTS', 'b19a77bd-6a02-4851-8116-9e915738b700', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('f1f526ee-a10e-4772-923b-ec3586826cbf', 'LIST_COLLECTION_EXERCISES', 'b19a77bd-6a02-4851-8116-9e915738b700', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('9fabaeb6-479f-4474-b22f-4ce1e9c06f9c', 'LIST_EMAIL_TEMPLATES', 'b19a77bd-6a02-4851-8116-9e915738b700', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('40d65e5c-5a07-43c8-8243-c263e2d26b78', 'LIST_EXPORT_FILE_DESTINATIONS', 'b19a77bd-6a02-4851-8116-9e915738b700', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('44945e73-f295-42b6-b240-d5d9aa57b217', 'LIST_EXPORT_FILE_TEMPLATES', 'b19a77bd-6a02-4851-8116-9e915738b700', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('81395c04-416c-4e3f-9397-83a08ac8bdf2', 'LIST_SMS_TEMPLATES', 'b19a77bd-6a02-4851-8116-9e915738b700', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('cc542d88-b1e6-4ab0-ba09-9857a4cc5877', 'LIST_SURVEYS', 'b19a77bd-6a02-4851-8116-9e915738b700', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('53d7355d-fce6-40e1-9dd9-17af1d9a0dfc', 'SEARCH_CASES', 'b19a77bd-6a02-4851-8116-9e915738b700', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('60e8bf0b-079d-4784-89b9-ab8613f23af0', 'VIEW_BULK_INVALID_PROGRESS', 'b19a77bd-6a02-4851-8116-9e915738b700', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('29a3b8ac-81ca-41c7-be4a-ceb57071a8c8', 'VIEW_BULK_REFUSAL_PROGRESS', 'b19a77bd-6a02-4851-8116-9e915738b700', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('80363171-0e29-4f01-b1f9-17272da66552', 'VIEW_BULK_UPDATE_SAMPLE_PROGRESS', 'b19a77bd-6a02-4851-8116-9e915738b700', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('23a7f3a1-194f-4455-adbd-e3da1047a88e', 'VIEW_BULK_UPDATE_SAMPLE_SENSITIVE_PROGRESS', 'b19a77bd-6a02-4851-8116-9e915738b700', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('91f93759-a0ba-41e6-b368-d331efb01366', 'VIEW_CASE_DETAILS', 'b19a77bd-6a02-4851-8116-9e915738b700', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('28e30f2e-2d1b-4fa1-92ca-cd8323179c55', 'VIEW_COLLECTION_EXERCISE', 'b19a77bd-6a02-4851-8116-9e915738b700', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('26cf0f7a-7f0f-4e5b-8be2-640745be9cdf', 'VIEW_SAMPLE_LOAD_PROGRESS', 'b19a77bd-6a02-4851-8116-9e915738b700', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('18c78ba8-17ec-4c09-972d-c1c6c88359d5', 'VIEW_SURVEY', 'b19a77bd-6a02-4851-8116-9e915738b700', NULL) ON CONFLICT DO NOTHING;

-- super
INSERT INTO casev3.user_group (id, description, name) VALUES ('8269d75c-bfa1-4930-aca2-10dd9c6a2b42', 'Super user - full permissions', 'super') ON CONFLICT DO NOTHING;;

INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('c469377e-680e-4cb1-92a0-5217be2b3a52', 'SUPER_USER', '8269d75c-bfa1-4930-aca2-10dd9c6a2b42', NULL) ON CONFLICT DO NOTHING;

COMMIT;