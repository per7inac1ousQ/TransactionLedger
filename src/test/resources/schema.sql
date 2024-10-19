DROP TABLE IF EXISTS consent;
CREATE TABLE consent
(
    id                                      uuid PRIMARY KEY,
    state                                   varchar(255),
    institution_id                          varchar(255),
    user_id                                 uuid,
    application_id                          uuid,
    application_user_id                     varchar(255),
    code_challenge_secret                   varchar(255),
    callback                                varchar(255),
    client_id                               varchar(255),
    access_token                            varchar(8192),
    refresh_token                           varchar(8192),
    consent_token                           varchar(8192),
    hashed_consent_token                    TEXT,
    config_version                          varchar(255),
    aspsp_consent_id                        varchar(255),
    encrypted_fields                        varchar(65536),
    payment_type                            varchar(255),
    status                                  varchar(255),
    transaction_from                        TIMESTAMP,
    transaction_to                          TIMESTAMP,
    authorized_at                           TIMESTAMP,
    expires_at                              TIMESTAMP,
    last_confirmed_at                       TIMESTAMP,
    reconfirm_by                            TIMESTAMP,
    created_at                              TIMESTAMP           DEFAULT now() NOT NULL,
    updated_at                              TIMESTAMP           DEFAULT now() NOT NULL,
    api_type                                varchar(255)        DEFAULT 'AISP' NOT NULL,
    institution_custom_attributes           varchar(65536)      NULL,
    one_time_token_requested                bool                DEFAULT FALSE NOT NULL,
    is_soft_deleted                         bool                DEFAULT FALSE,
    is_ready_for_archival                   bool                DEFAULT FALSE,
    is_deleted_by_institution               bool                DEFAULT NULL,
    awaiting_ott_exchange                   bool                DEFAULT FALSE NOT NULL
);

CREATE INDEX consent_application_id_uindex ON consent (application_id);
CREATE INDEX consent_user_id_uindex ON consent (user_id);

INSERT INTO public.consent (state,institution_id,application_user_id,code_challenge_secret,callback,client_id,access_token,refresh_token,consent_token,hashed_consent_token,config_version,aspsp_consent_id,encrypted_fields,payment_type,id,application_id,user_id,status,created_at,updated_at,api_type,institution_custom_attributes,authorized_at,expires_at,transaction_from,transaction_to,one_time_token_requested,awaiting_ott_exchange) VALUES
('dp237e69-9696-4b26-aa7c-88343db8d38c','mock-sandbox','user_0.22829288365559555','',NULL,'3fc339ca-6338-4f43-9e1c-bafc4362041c','','','','','1.0','PDC_4e6d9667-baed-4437-b50a-29a24dd1cd56','eyJraWQiOiIwMWZjZGE0Yi1mZWNhLTQ4NTctYjMwOC0zMWJmYmFiZTNkNTQiLCJhbGciOiJFUzI1NiJ9.ZXlKbGNHc2lPbnNpYTNSNUlqb2lSVU1pTENKamNuWWlPaUpRTFRJMU5pSXNJbmdpT2lJMmFuSnNia1ZZVjFOSWRUTkpYMGt6VkZrMmRrdEVjbW80YTFSWlRsRklNSFpvT1hSeWIzbHdORXROSWl3aWVTSTZJbFZVV1c5RWVEbEpkWGhEY0RSRlRHeDVWbFJaVkd0c0xYcGZla1Z5TlV4ak9WWjFWMUZCTFVGVU0zY2lmU3dpYTJsa0lqb2laRFV6TUdNNVl6QXRObVppTVMwMFpXRm1MV0ZoWkRjdFl6QTJOV00zTmpZMVpHWTVJaXdpWlc1aklqb2lRVEkxTmtOQ1F5MUlVelV4TWlJc0ltRnNaeUk2SWtWRFJFZ3RSVk1yUVRJMU5rdFhJbjAuUzZxMHZWWEFtUXA1MDBvYUh3UVIxWkF6Zk16c0xLMGVDVzBrVmFBeHFMZHpXRkt3d2M4RTNTd3AtdXE5c05fNVN5Z185VHRwVkktcmg0T2U2VUZKZjFISXRtS0tNV3BDLkctRk4tUVRRYm96dGh2NjViajNJOWcuOHljU1NDVHFrZnZfck1yQ2ZUdGxXRkF4Skd5WTU1NFdLY3FaTWNBSDl0bW9xdnlCRUQ5UXoyX3VWSzJkaFh0T2hzQlJyWFRxY3JWajc0b2R1WEExUE94enRBSGRXVEI2Q1laUjVLNFlSZEZwbVcwY2pzYVYzSHEyUWMtbDZuMGRqU0xtdTJ5RF96Qk51R1JmdDhTTEMyU2xqamhZZl91Q2NSbWVlSXFHZC1mX2VqVGJVVkdZbFpDOW5PUU5LU0NtWk9jVDVmZUNZWmtPdHNvdUxmWVBuanl3Nm5ZYVNONVBuQnMwd3BiOE9KYWowNlNZZmNZbGo5YUNNaXNBWVlLbUNWVkp4X3N3eTROenItTjVxT0JtN1RsOC1RVURubmFuNjk4c1JPdGRYM3ZOU2FPbC1kbFNaMEluLWFtNEo5YW92Z0duNTdsQWx5MTFIeWE5anZlbklzOG9yZUN5cERSOEZHQjY5alJyXy1VcUV6Ty1Ya2hZWmZjQlpxSmFFQ3ItRmU2dy1WcVdwR0N1b1JzbzFISlc1QS1mZndGVnBvc0pTNVlULVkxZlh3WkNNS3c1bTZVRU1aOE1meGNPVUdNejh1TmtDbUw2WTlEZi14Uk50Y081VnpVb20yMjJ5SjlibVpGN2xBLVJUMWw4ZXpEZmhxeUQtQlVrbjYwZTRlTEpzbTR4dGhMSDJUV2tJWnpwQm1JQ1hmRGlnOXlob0ZWUDNDc3A4cU1neVdXbGRmSTVnS2FmQ1hHZnd4ZmE4Xy0tOVItT1RHRVJQdk1TYmxqLWtGSmVyRHVUYzlTdHNBSlc4WEpXS0ZVYUp2aGp3dmVlU0dLMEZaLU5UY0hYM0RVZ0IxS2ZMeDFoUHRIczBZTUZTbWcydko4ckdvWDZLRDFkZXNlcHRTc2pra19sd0lpdkZOTmRad3gyaXJCLVlyVGdrY3ZuYzQ2d2tiV1ZLc1FrOE9WTGdZS1ZtZWh0N2pEWDI0akJsVlRSRG15ZHBqU3JzSTNiWjY0d3A4SXNuRHZkV21mV2dlaWE3SGxZR3owaDVhRm1kU1FhMnREdUUybnJPdjlGZzc0OEtLRXE0d01IN1FLM04zdmw5ajdfWGRvLUM2VU5QU3JiVFhqMFZDbDNUNzlSRVEwTnNSbGgyU2dBeGNtSVI3OW5NbUF5ck8yNVhDZzRsZFJfWUdlLVdtRExKRWk3MnpHNWxQOVZrdkZmTWVNOHhzSW5tX3ZTeXdEM1QwT3FNT1R1cllMNUtmVk9UZjU0WW9OTVJ0Ni1iNXctMmhNZEpsWm0zZUVGRmVkQkM3VWpvV0FyMEh6bjJ2SGh5UDFFcHdCMGJCUkQxQ29oXzB0VmlnbXR0c3RXVVl5Z1poOUR5MEx0SERaclhTQk5KaVdYQUlUbUVWUl9uSl9OMHJxNXlFeDg2WTFhQ2tMOGttZ3hZUTdRNGtpNnRhTEhoeFZzbzJrUDZXRmUyNE05U2NEZEpfUFlfbGNLZUxmZm5zU2lVclp6TVhsbExYNHFacWg3eTNzcGxEZTR1VW5DSmxxVmpMQ0cxa3NKVnRoYWJqd3NwZlNldWlMRE5peTVBbU1kV2JESmg0ZFVpUE5oWFk2SEw1UlhxelNQbm10dkVDZmd3Q3h6VUtpal94M3dLczlJRjkwcDNGeVk5MFhsdGJaazVlaEhJX2hBTUZLcUlmMzk5WFdtdXhxZFY0NmFZdmwyLXREV1J4cXAwMHNGbVk5V1ZiZXR4bjllMDl1OTh6Z1ZOZ2piRmJBWWUyMkNVeERQeTJRRElLLTVFZ2NiOURJaW9EUjVoQU85LWxoeUkzLXJPUlhhVXpnbnJoa1d0RWR5UkpoZURNRG5vdnBYa19Cb2c4TGdMMUJfTHZvLTZCYXBkR29MZ3NWZVBiN1ZlUXdnaUhnOVh0dm5BNVMtQjl0aTF3ZFJsbHlkeEhKQWQ3UGdKNW90SEEySUREM211ODh6Z3Y0MHFzcEh1WWk1bTQxS2Y1anF1dXo3aVpsWGVlaGtYdWVwaS1McUlLb3I2SmJqX1BrN2lDWGNWTlQ1aEpwdjFDNnN1VnZMMG9oaWlkTDRvYl96VGdsWk1vZ2lOd1NORVptOGNDOC5QTUhLMHZxMlF1bVNUM2JHaWF0YnFnZGZURXdoclB2SS13WWktNGtLZ1BN.Uz1HxlRerchSTWPJN1HC2pTOmeX6suTmM_YB6VNNKVmquHf-ZWBS5xYo966Bk75Es6pkwiq3d5bhDc823ATecQ','DOMESTIC_PAYMENT','f2684704-ea0d-4bf4-bad9-13c291e37a33'::uuid,'f5351d2a-b592-444f-9baf-5be6fd0ca406'::uuid,'985abd8b-141b-405c-bdad-8337c88e30e6'::uuid,'CONSUMED','2020-10-29 16:09:20.364661','2020-10-29 16:09:20.364661','AISP',NULL,NULL,NULL,NULL,NULL,false,false);

-- Consent Features

DROP TABLE IF EXISTS consent_feature;
CREATE TABLE consent_feature
(
    consent_id    UUID NOT NULL,
    feature TEXT NOT NULL
);

INSERT INTO consent_feature (consent_id, feature) VALUES ('f2684704-ea0d-4bf4-bad9-13c291e37a33'::uuid, 'ACCOUNTS');
