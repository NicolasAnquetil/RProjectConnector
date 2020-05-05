Class {
	#name : #RLangageExpressionTest,
	#superclass : #RCollectionTest,
	#category : #'RConnector-Tests'
}

{ #category : #tests }
RLangageExpressionTest >> testLangageListAddThreeElements [
	| langageList |
	"List = Last In First Out"
	langageList := RLangageExpression newEmptyChainedList.
	langageList add: 2.
	langageList add: (RObject findFun:'~').
	langageList add: 3.
	self assert: langageList size equals: 3.
	self assert: langageList third asRObject asOrderedCollection equals: #(3) asOrderedCollection
]

{ #category : #tests }
RLangageExpressionTest >> testLangageListCreationFromNil [
	| langageList |
	langageList := RLangageExpression newEmptyChainedList.
	langageList add: 2.
	self assert: langageList size equals: 1.
	self assert: langageList first asRObject asOrderedCollection equals: #(2) asOrderedCollection.
	self assert: langageList typeOf equals: #LANGSXP
]

{ #category : #tests }
RLangageExpressionTest >> testLangageListEvaluationShouldSubstractInTheGoodOrder [
	| langageList |
	"2-3"
	langageList := RLangageExpression newEmptyChainedList.
	langageList addLast: (RObject findFun:'-').
	langageList addLast: 2.
	langageList addLast: 3.
	self assert: langageList size equals: 3.
	self assert: langageList third asRObject asOrderedCollection equals: #(3) asOrderedCollection.
	self assert: langageList eval first equals: -1.
]

{ #category : #tests }
RLangageExpressionTest >> testLangageListWithOneElementShouldEvaluate [
	| langageList |
	langageList := RLangageExpression newEmptyChainedList.
	langageList add: (RObject prim_install: '-').
	langageList add: 2.
	self assert: langageList eval first equals: -2
]
