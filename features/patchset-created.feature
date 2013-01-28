
# NOTE: the urls here are from Gerrit instance which people can’t access. Don’t try to run tests for now :)

Feature: Use patchset-created Gerrit hook

This hook allows sending notifications to Integrity about that there is new
change to build by giving additional arguments to it that tells what to
checkout.

    Scenario: do basic call to alarmsystem
        Given PatchsetCreated created
        And patchset’s input arguments are:
         | change    | 2447                                     |
         | is-draft  | false                                    |
         | change-url| https://service.slm.fi/gerrit/#/c/2447/  |
         | project   | alarmsystem                              |
         | branch    | master                                   |
         | topic     |                                          |
         | uploader  | Test Uploader                            |
         | commit    | dummy                                    |
         | patchset  | 2                                        |
        When build request is submitted
        Then validate that build succeeds

    Scenario: do basic call to slam/skeleton
        Given PatchsetCreated created
        And patchset’s input arguments are:
         | change    | dummy                                    |
         | is-draft  | false                                    |
         | change-url| https://service.slm.fi/gerrit/#/c/2363/  |
         | project   | slam/skeleton                            |
         | branch    | master                                   |
         | topic     |                                          |
         | uploader  | Test Uploader                            |
         | commit    | dummy                                    |
         | patchset  | 6                                        |
        When build request is submitted
        Then validate that build succeeds

    Scenario: ensure that failing tests fails build at slam/skeleton
        Given PatchsetCreated created
        And patchset’s input arguments are:
         | change    | dummy                                    |
         | is-draft  | false                                    |
         | change-url| https://service.slm.fi/gerrit/#/c/2253/  |
         | project   | slam/skeleton                            |
         | branch    | master                                   |
         | topic     |                                          |
         | uploader  | Test Uploader                            |
         | commit    | 4d1ebdb56b7adede7e42c0f71f3e7eefa0f7c10d |
         | patchset  | 1                                        |
        When build request is submitted
        Then validate that build fails

    Scenario: ensure that test to excluded project works
    TODO: see if this actually tests anything real
        Given PatchsetCreated created
        And patchset’s input arguments are:
         | change    | 2402                                     |
         | is-draft  | false                                    |
         | change-url| https://service.slm.fi/gerrit/#/c/2402/  |
         | project   | conf                                     |
         | branch    | master                                   |
         | topic     |                                          |
         | uploader  | Test Uploader                            |
         | commit    | dummy                                    |
         | patchset  | 1                                        |
        When build request is submitted
        Then validate that build succeeds

    Scenario: ensure that test to project which uses ”all” include block works
        Given PatchsetCreated created
        And patchset’s input arguments are:
         | change    | dummy                                    |
         | is-draft  | false                                    |
         | change-url| https://service.slm.fi/gerrit/#/c/2414/  |
         | project   | slam/class/payment                       |
         | branch    | master                                   |
         | topic     |                                          |
         | uploader  | Test Uploader                            |
         | commit    | dummy                                    |
         | patchset  | 2                                        |
        When build request is submitted
        Then validate that build succeeds