package com.radiadesign.relationalscope.expression

import com.radiadesign.relationalscope.RelationalScopeBuilder
import com.radiadesign.relationalscope.RelationalScope

class AncestorWalkingPropertyExpression extends AbstractPropertyExpression {
  
  def allowCorrelation
  
  AncestorWalkingPropertyExpression(_propertyKey, _allowCorrelation, RelationalScopeBuilder _builder) {
    super(_propertyKey, _builder)
    
    allowCorrelation = _allowCorrelation
  }
  
  def propertyFor(options) {
    def associationDescriptorStack = options.associationDescriptorStack
    def actualPropertyKey = propertyKey
    def curIndex = associationDescriptorStack.size() - 1
    def associationDescriptor = associationDescriptorStack.empty() ? null : associationDescriptorStack.peek()
    
    def associationPath = associationDescriptor?.path
    while (actualPropertyKey.startsWith('../')) {
      def associationDomainProperty = associationDescriptor.associationDomainProperty
      
      if ( associationDomainProperty?.isOneToMany()
           && !allowCorrelation ) {
        // If we have a has-many property here, then we are going to walk above the
        // "parent collection." This means we now now causing correlated queries.
        // -- Require the user to have explicitly confirmed that this is intentional.
        throw new RuntimeException("Use of the '../' operator in property '${propertyKey}' attempted to walk beyond the has-many collection '${associationDomainProperty.name}'. This will cause correlated sub-queries to be generated. If this is intentional, please pass 'correlation: true' as part of the param <options> map to the 'property()' call.")
      }
      
      --curIndex
      if (curIndex < 0) {
        // We have to check this during actual criterion compilation rather than at creation
        // time since at creation time we don't know if we will be nested later on...
        throw new RuntimeException("Use of the '../' operator in property '${propertyKey}' attempted to walk beyond the scope's root domain class.")
      }
      
      actualPropertyKey = actualPropertyKey.substring(3)
      associationDescriptor = associationDescriptorStack[curIndex]
      associationPath = associationDescriptor.path
    }
    
    def newOptions = options + [associationPath: associationPath]
    RelationalScope.propertyFor(newOptions, actualPropertyKey, associationDescriptor)
  }
  
}