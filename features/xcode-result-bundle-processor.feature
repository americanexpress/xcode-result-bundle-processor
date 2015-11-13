Feature: My bootstrapped app kinda works
  In order to get going on coding my awesome app
  I want to have aruba and cucumber setup
  So I don't have to do it myself

  Scenario: App just runs
    When I get help for "xcode-result-bundle-processor"
    Then the exit status should be 0
    And the banner should be present
    And there should be a one line summary of what the app does
    And the banner should document that this app takes options
    And the following options should be documented:
      | --version |
    And the banner should document that this app's arguments are:
      | results_bundle_path | which is required |

  Scenario: Happy Path
    When I successfully process "results_bundle_path"
    Then the output should contain all of these lines:
      | t =     0.00s     Start Test                                       |
      | t =    18.51s     Tear Down                                        |
      | CM4954_Validate_Attempt_Login_With_Invalid_Password/test() Success |
      | Check predicate `exists == 0` against object `ActivityIndicator`   |

  Scenario: Tarballed results bundle path
    When I successfully process "results_bundle_path.tar.gz"
    Then the output should contain all of these lines:
      | t =     0.00s     Start Test                                       |
      | t =    18.51s     Tear Down                                        |
      | CM4954_Validate_Attempt_Login_With_Invalid_Password/test() Success |
      | Check predicate `exists == 0` against object `ActivityIndicator`   |

