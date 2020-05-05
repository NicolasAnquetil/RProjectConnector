"
A TRLibrary is a trait defining the name of the external library.
The external library is named R.dll under W7 and libR.so under linux. The name defined in nbLibraryNameOrHandle should not  be changed.

Under w7,The R.dll itself is not self sufficiant so some 32bits libs should be added too :
	- Rblas.dll
	- Rgraphapp.dll
	- Riconv.dll
	- Rlapack.dll
	- Rzlib.dll
	
Under linux, it should work fine if  you have a x32bits edition else good luck... (it tried but not succeded)
"
Trait {
	#name : #TRLibrary,
	#category : #'RConnector-Core'
}

{ #category : #'trait - library path' }
TRLibrary classSide >> ffiLibraryName [
 ^ #R
]

{ #category : #'trait - library path' }
TRLibrary >> ffiLibraryName [
 ^ self class nbLibraryNameOrHandle
]
