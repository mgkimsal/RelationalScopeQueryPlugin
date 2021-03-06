Feature: Basic queries
  In order to perform more advanced queries than allowed by GORM
  As a developer
  I want to query using scopes
  
  Scenario: Query for all instances
    Given I have the following domain class:
      """
      class Person {
        String name
        String email
        String email2
        String gender
        
        static constraints = {
          gender(nullable: true)
          email(nullable: true)
          email2(nullable: true)
        }
      }
      """
    And I have created the following "Person" instances:
      | name    |
      | Gregory |
      | Harold  |
      | Alice   |
    When I execute the code "Person.where { }.all()"
    Then I should get the following results:
      | name    |
      | Gregory |
      | Harold  |
      | Alice   |
  
  Scenario: Conveniently query by domain identifier by accessing the domain like a list
    Given I have created the following "Person" instances:
      | name    |
      | Gregory |
    When I execute the code "[Person[(Person.list() as ArrayList)[-1]?.id]]"
    Then I should get the following results:
      | name    |
      | Gregory |
  
  Scenario: Query by a single property
    Given I have created the following "Person" instances:
      | name    |
      | Gregory |
      | Harold  |
      | Alice   |
    When I execute the following code:
      """
      Person.where { name equals: "Gregory" }.all()
      """
    Then I should get the following results:
      | name    |
      | Gregory |
  
  Scenario: Query by a single property
    Given I have created the following "Person" instances:
      | name    |
      | Gregory |
      | Harold  |
      | Alice   |
    When I execute the following code:
      """
      Person.where { name in: ["Gregory", "Harold"] }.all()
      """
    Then I should get the following results:
      | name    |
      | Gregory |
      | Harold  |
  
  Scenario: Limit queries with a take() chain method
    Given I have created the following "Person" instances:
      | name    |
      | Gregory |
      | Harold  |
    When I execute the following code:
      """
      Person.where { }.take(1).all()
      """
    Then I should get the following results:
      | name    |
      | Gregory |
  
  Scenario: Scroll results of queries with a skip() chain method
    Given I have created the following "Person" instances:
      | name    |
      | Gregory |
      | Harold  |
    When I execute the following code:
      """
      Person.where { }.skip(1).all()
      """
    Then I should get the following results:
      | name    |
      | Harold |
  
  Scenario: Query with a scope
    Given I have created the following "Person" instances:
      | name    | gender |
      | Gregory | male   |
      | Harold  | male   |
      | Alice   | female |
    When I execute the following code:
      """
      def men = Person.where { gender equals: "male" }
      men.all()
      """
    Then I should get the following results:
      | name    |
      | Gregory |
      | Harold  |
  
  Scenario: Query with "or" clause
    Given I have created the following "Person" instances:
      | name    | gender |
      | Gregory | male   |
      | Harold  | male   |
      | Alice   | female |
    When I execute the following code:
      """
      Person.where {
        or {
          name equals: "Harold"
          name equals: "Alice"
        }
      }.all()
      """
    Then I should get the following results:
      | name    |
      | Harold  |
      | Alice   |
  
  Scenario: Query with "property ne: value" clause (should hide SQL ternary logic)
    Given I have created the following "Person" instances:
      | name    | gender |
      | Gregory | male   |
      | Sally   | female |
    Given I have created the following "Person" instances:
      | name    |
      | Harold  |
    When I execute the following code:
      """
      Person.where {
        gender ne: "female"
      }.all()
      """
    Then I should get the following results:
      | name    |
      | Gregory |
      | Harold  |
  
  Scenario: Query with "property ne: property" clause (should hide SQL ternary logic)
    Given I have created the following "Person" instances:
      | name    | email         |
      | Gregory | greg@me.com   |
      | Sally   | sally@me.com  |
    Given I have created the following "Person" instances:
      | name    |
      | Bob     |
    Given I have created the following "Person" instances:
      | name    | email       | email2      |
      | Tim     | tim@me.com  | tim@me.com  |
    Given I have created the following "Person" instances:
      | name    | email2         |
      | Harold  | harold@me.com  |
    When I execute the following code:
      """
      Person.where {
        email ne: property("email2")
      }.all()
      """
    Then I should get the following results:
      | name    |
      | Gregory |
      | Sally   |
      | Harold  |
  
  Scenario: Query with list of scopes
    Given I have created the following "Person" instances:
      | name    | email         |
      | Gregory | greg@me.com   |
      | Sally   | sally@me.com  |
    Given I have created the following "Person" instances:
      | name    |
      | Bob     |
    Given I have created the following "Person" instances:
      | name    | email       | email2      |
      | Tim     | tim@me.com  | tim@me.com  |
    Given I have created the following "Person" instances:
      | name    | email2         |
      | Harold  | harold@me.com  |
    When I execute the following code:
      """
      Person.where( [
        { email ne: property("email2") },
        { email is: notNull }
      ] ).all()
      """
    Then I should get the following results:
      | name    |
      | Gregory |
      | Sally   |