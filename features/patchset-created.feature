
Feature: Use patchset-created Gerrit hook

This hook allows sending notifications to Integrity about that there is new
change to build by giving additional arguments to it that tells what to
checkout.

    Scenario: do basic call
        Given PatchsetCreated created
        And patchset’s input arguments are:
         | change    | 1622                                     |
         | is-draft  | false                                    |
         | change-url| https://service.slm.fi/gerrit/#/c/1622/  |
         | project   | alarmsystem                              |
         | branch    | master                                   |
         | topic     |                                          |
         | uploader  | Test Uploader                            |
         | commit    | 1e53274b5b1846c509f436a30ccaa2eba1051412 |
         | patchset  | 1                                        |
        When build request is submitted
        Then validate that build succeeds