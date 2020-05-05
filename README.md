# RProjectConnector
RProjectConnector is a library providing a binding between Pharo and [R](http://www.r-project.org).
It was recovered from a SmalltalkHub project with the same name created by [Vincent Blondeau](https://github.com/VincentBlondeau).

The following is a copy of the previous project ReadMe

This binding is done through UFFI primitive calls
(a NativeBoost binding version can be found in the history of the project).

# Installation

In order to get it work, you should get the R libs.

## Under ubuntu

It is better to have a 32 bits version of Ubuntu to get the libraries.
I tried under a 64 bits versions and I not succeded to do it work. To get them:

```Smalltalk
dpkg --add-architecture i386
apt-get update
apt-get install r-base-core:i386https://github.com/VincentBlondeau
```

And copy the librairies ("libR.so") in the Pharo vm folder.

## Under Windows 7

You should install R in 32bits (http://cran.r-project.org/bin/windows/base/) and copy the files R.dll, Rblas.dll, Rgraphapp.dll, Riconv.dll, Rlapack.dll and Rzlib.dll from R-3.1.1\bin\i386 to the pharo vm folder.

The libraries alone are not enough, you need to install R completly.

## Under MacOs

Not tried

# Package Loading

Once you have your libraries, you can launch a Pharo image with the RProjectConnector installed:

```Smalltalk
Gofer it 
    smalltalkhubUser: 'VincentBlondeau' project: 'RProjectConnector';
    configuration;
    loadStable
```

You have to restart Pharo to initialize the binding.

If you forgot to install the libraries or if they are not well installed, you should received a error startup but you are still able to launch your image.

# Features and examples

If you want to execute a R function, you should (for now) know what is the name of the function and the parameters that it takes. If you misspeled the function name, the Pharo image will crash (that's a feature of R, that doesn't handle well the errors ;) ).

For example, if you want to evaluate the method 'acf' (Autocorrelation function) on a sample of data, you can do:

```Smalltalk
 data := (1 to: 1000) collect: #yourself.
 res := 'acf' asREval: {data}
```

You should get a representation of a list under R (a RList) and you can interract with it by accessing the items either by index or by key (the list are kind of dictionnary-arrays):

```Smalltalk
 res at: 'coef'
 res at: 1
```

Moreover, you have the visualisation of the acf opened in a other window.

Like that, you can evaluate any method with ordered parameters.

Some other examples with named and not named parameters:

```Smalltalk
 'plot'
      asREval:
           {(Object allSubclasses collect: #numberOfMethods).
           (Object allSubclasses collect: [ :e | e name size ]).
           ('xlim' -> #(0 700)).
           ('ylim' -> #(0 700)).
           ('xlab' -> 'Nb of Methods').
           ('ylab' -> 'Name lengthf').
           ('pch' -> 21).
           ('las' -> 1).
           ('bg' -> 'gold').
           ('cex' -> 1.6).
           ('cex.lab' -> 1.4).
           ('cex.axis' -> 1.4)}
```

For now there is no control of session in the image, try to not use R objects from previous sessions...

# To do

-    Add the error handling on function accessing: https://stat.ethz.ch/pipermail/r-devel/2007-July/046261.html
-    Add the named function arguments (Almost done in developpement version)
-    Add missing types: matrix, data frames,...
-    Plot importer
-    Add invalidation of old handles at startup

# Links

-    Some documentation on external R library on: http://www.math.ncu.edu.tw/~chenwc/R_note/reference/package/R-exts.pdf (p64)
-    The RSources http://cran.r-project.org/sources.html. The header C file R-3.1.1\src\include\Rinternals.h shows all the functions that can be called through the primitives. For information, the compilation variable "USE_RINTERNALS" is not defined in the compiled libraries.
-    Documentation on R environments: http://adv-r.had.co.nz/Environments.html
-    Example in C: https://gist.github.com/Sharpie/323498
-    The equivalent in Java but using the RServer: http://www.rforge.net/Rserve/
