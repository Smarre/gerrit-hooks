
# NOTE: the urls here are from Gerrit instance which people can’t access. Don’t try to run tests for now :)

Feature: Request manual build from Integrity

When tests have failed for some external reason, there is suspect that another build would
yield different resolution or some other reason, there may be need to request manual
build from Integrity for specific Gerrit change set and update change’s verified status
accordingly.

    Scenario: request manual build from Gerrit
        Given manual build request is issued with data:
         | change-id    | 2363                                     |
         | project      | slam/skeleton                            |
         | patchset-id  | 1                                        |
        Then validate that build succeeds

    Scenario: request manual build from Gerrit
        Given manual build request is issued with data:
         | change-id    | 2399                                     |
         | project      | po-public_html                           |
         | patchset-id  | 1                                        |
        Then validate that build succeeds