Feature: Basic result bundle processing

  Scenario: User requests help
    When I get help for "xcode-result-bundle-processor"
    Then the exit status should be 0
    And the banner should be present
    And there should be a one line summary of what the app does
    And the banner should document that this app takes options
    And the following options should be documented:
      | --version |
    And the banner should document that this app's arguments are:
      | results_bundle_path | which is required |
    And the following options should be documented:
      | save-html-report |

  Scenario: Processing directory result bundle
    When I successfully process "results_bundle_path"
    Then the output should contain all of these lines:
      | CM4954_Validate_Attempt_Login_With_Invalid_Password/test() Passed |
      | Check predicate `exists == 0` against object `ActivityIndicator`  |
      | Success!                                                          |


  Scenario: Processing tarballed results bundle path
    When I successfully process "results_bundle_path.tar.gz"
    Then the output should contain all of these lines:
      | CM4954_Validate_Attempt_Login_With_Invalid_Password/test() Passed |
      | Check predicate `exists == 0` against object `ActivityIndicator`  |
      | Success!                                                          |

