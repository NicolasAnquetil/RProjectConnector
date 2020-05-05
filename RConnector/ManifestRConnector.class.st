"
I store metadata for this package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestRConnector,
	#superclass : #PackageManifest,
	#category : #RConnector
}

{ #category : #'meta data' }
ManifestRConnector class >> rejectClasses [
^ #()
]

{ #category : #'meta data' }
ManifestRConnector class >> rejectRules [
^ #()
]

{ #category : #'code-critics' }
ManifestRConnector class >> ruleClassNotReferencedRuleV1FalsePositive [
	^ #(#(#(#RGClassDefinition #(#ManifestRConnector)) #'2016-08-31T14:36:03.227112+02:00') )
]

{ #category : #'meta data' }
ManifestRConnector class >> ruleExcessiveVariablesRuleV1FalsePositive [
^ #(#(#(#RGClassDefinition #(#RLibTypes)) #'2014-12-05T15:32:37.504912+01:00') )
]

{ #category : #'meta data' }
ManifestRConnector class >> ruleInconsistentMethodClassificationRuleV1FalsePositive [
^ #(#(#(#RGMethodDefinition #(#RNilValue #asRObject #false)) #'2014-12-05T15:32:37.534912+01:00') )
]

{ #category : #'meta data' }
ManifestRConnector class >> ruleTempsReadBeforeWrittenRuleV1FalsePositive [
^ #(#(#(#RGMethodDefinition #(#'RSession class' #initEmbeddedR: #true)) #'2014-12-05T15:32:37.567912+01:00') )
]
