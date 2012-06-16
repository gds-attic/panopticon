Feature: Registering resources
  In order to introduce new resources into the system
  I want to register artefacts in panopticon
  So that it can co-ordinate the system
  
  Scenario: Creating a smart answer
    When I put a new smart answer's details into panopticon
    Then a new artefact should be created
      And rummager should be notified
      And the router should be notified

  Scenario: Updating a smart answer
    When I put updated smart answer details into panopticon
    Then the relevant artefact should be updated
      And the API should reflect the change
      And rummager should be notified
      And the router should be notified

  Scenario: Creating a draft item
    When I put a draft smart answer's details into panopticon
    Then a new artefact should be created
      And rummager should not be notified
      And the router should not be notified

  Scenario: Putting an item whose slug is owned by another app
    When I put a new item into panopticon whose slug is already taken
    Then I should receive an HTTP 409 response
      And the relevant artefact should not be updated
