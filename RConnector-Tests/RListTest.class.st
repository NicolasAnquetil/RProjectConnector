"
A RListTest is a test of the RList.

"
Class {
	#name : #RListTest,
	#superclass : #RCollectionTest,
	#category : #'RConnector-Tests'
}

{ #category : #tests }
RListTest >> testAccessAllElementsOfAList [
	| list |
	list := RList new: 1.
	self assert: list size equals: 0
]

{ #category : #tests }
RListTest >> testAccessItemFromEmptyListShouldNotBeAllowed [
	self should: [ RList new: 0 ] raise: Error
]

{ #category : #tests }
RListTest >> testCreateListWithOneElement [
	| list |
	list := (RList new: 1)
		add: 'tseries';
		yourself.
	self assert: (list first isKindOf: RStringVector).
	self assert: list first first value equals: 'tseries'
]

{ #category : #tests }
RListTest >> testCreateListWithOneNamedElement [
	| list |
	list := (RList new: 1)
		addAt: 'repo' value: 'http://cran.rstudio.com/';
		yourself.
	self assert: (list first isKindOf: RStringVector).
	self assert: list first first value equals: 'http://cran.rstudio.com/'.
	self assert: (list at: 'repo') first value equals: 'http://cran.rstudio.com/'
]

{ #category : #tests }
RListTest >> testCreateListWithOneNilNamedElement [
	| list |
	list := RList new.
	list add: 'http://cran.rstudio.com/'.
	self assert: (list first isKindOf: RStringVector).
	self assert: list first first value equals: 'http://cran.rstudio.com/'.
	self should: [ list at: nil ] raise: NotFound
]

{ #category : #tests }
RListTest >> testCreateListWithTwoElementsOneNamedOneNot [
	| list |
	list := (RList new: 2)
		add: 'tseries';
		addAt: 'repo' value: 'http://cran.rstudio.com/';
		yourself.
	self assert: (list first isKindOf: RStringVector).
	self assert: list first first value equals: 'tseries'.
	self assert: (list second isKindOf: RStringVector).
	self assert: list second first value equals: 'http://cran.rstudio.com/'.
	self assert: (list at: 'repo') first value equals: 'http://cran.rstudio.com/'
]

{ #category : #tests }
RListTest >> testEmptyListShouldAreForbidden [
	self should: [ RList new: 0 ] raise: AssertionFailure description: 'The initial size should not be zero!'
]
