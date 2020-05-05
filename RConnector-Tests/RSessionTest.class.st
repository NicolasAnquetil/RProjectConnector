"
A RConnectorTest contains the tests for the statup and the installation of libs
"
Class {
	#name : #RSessionTest,
	#superclass : #RAbstractTest,
	#category : #'RConnector-Tests'
}

{ #category : #tests }
RSessionTest >> testIfSessionIsValid [
	"If this test is not working, it means that the RConnector can be used because the session is not initialized"
	RSession checkWorking.
]

{ #category : #tests }
RSessionTest >> testInstallPackageShouldWork [
	<expectedFailure>
	| res |
	self fail.
	RFunction
		eval: 'install.packages'
		withListParameter:
			{'tseries'.
			('repo' -> 'http://cran.rstudio.com/')}.
	res := RFunction eval: 'library' withParameters: {'forecast'. }.
	self assert: res value equals: 'forecast'
]

{ #category : #tests }
RSessionTest >> testLoadLibraryShouldNotWorkIfThePackageIsNotInstalled [
	self should: [ RFunction eval: 'library' withParameters: {'MARSS'} ] raise: REvaluationError  whoseDescriptionIncludes:  'MARSS'  description: 'Be sure that the evaluation error is because of the package and not something else'
]

{ #category : #tests }
RSessionTest >> testProxySetting [
	<expectedFailure>
	| proxy |
	self fail.
	proxy := 'proxy:3128'.
	self assert: ('Sys.setenv' asREval: {('http_proxy' -> proxy)}) first equals: true.
	self assert: ('Sys.getenv' asREval: {'http_proxy'. }) first value equals: proxy
]
