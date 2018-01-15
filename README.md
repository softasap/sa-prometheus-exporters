sa-prometheus-exporters
=======================

[![Build Status](https://travis-ci.org/softasap/sa-prometheus-exporters.svg?branch=master)](https://travis-ci.org/softasap/sa-prometheus-exporters)

Re-usable list of exporters usually used with Prometheus


Example of usage:

Simple

```YAML

     - {
         role: "sa-prometheus-exporters"
       }


```

Advanced

```YAML

     - {
         role: "sa-prometheus-exporters"
       }


```



Usage with ansible galaxy workflow
----------------------------------

If you installed the `sa-prometheus-exporters` role using the command


`
   ansible-galaxy install softasap.sa-prometheus-exporters
`

the role will be available in the folder `library/softasap.sa-prometheus-exporters`
Please adjust the path accordingly.

```YAML

     - {
         role: "softasap.sa-nginx"
       }

```




Copyright and license
---------------------

Code is dual licensed under the [BSD 3 clause] (https://opensource.org/licenses/BSD-3-Clause) and the [MIT License] (http://opensource.org/licenses/MIT). Choose the one that suits you best.

Reach us:

Subscribe for roles updates at [FB] (https://www.facebook.com/SoftAsap/)

Join gitter discussion channel at [Gitter](https://gitter.im/softasap)

Discover other roles at  http://www.softasap.com/roles/registry_generated.html

visit our blog at http://www.softasap.com/blog/archive.html 
