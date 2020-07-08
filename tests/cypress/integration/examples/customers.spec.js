/// <reference types="cypress" />

context("Customers", () => {
  beforeEach(() => {
    cy.visit("/#/customers");
  });

  it("should display page title", () => {
    cy.contains("Customers", { timeout: 20000 }).should("exist");
  });
});
