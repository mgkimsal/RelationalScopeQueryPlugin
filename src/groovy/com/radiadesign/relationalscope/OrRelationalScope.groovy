package com.radiadesign.relationalscope

import org.hibernate.criterion.*
import org.codehaus.groovy.grails.commons.DefaultGrailsDomainClass

class OrRelationalScope extends RelationalScope {
  
  // --------------------------------------------------------------------------
  // Constructors
  // --------------------------------------------------------------------------
  
  OrRelationalScope() {
    super()
  }
  
  OrRelationalScope(DefaultGrailsDomainClass _grailsDomainClass) {
    super(_grailsDomainClass)
  }
  
  //OrRelationalScope(JSONObject json) {
  //  super(json)
  //}
  
  private OrRelationalScope(_grailsDomainClass, ArrayList _scopes) {
    super(_grailsDomainClass, _scopes)
  }
  
  
  // --------------------------------------------------------------------------
  // Private API
  // --------------------------------------------------------------------------
  
  def instance() {
    new OrRelationalScope()
  }
  
  def junction() {
    Restrictions.disjunction()
  }
  
}