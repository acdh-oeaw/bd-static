# Baedeker Digital



* data is fetched from https://github.com/acdh-oeaw/bd-data
* build with [DSE-Static-Cookiecutter](https://github.com/acdh-oeaw/dse-static-cookiecutter)


## initial (one time) setup

* run `./shellscripts/dl_saxon.sh`
* run `./fetch_data.sh`
* run `ant`

## set up GitHub repo
* create a public, new, and empty (without README, .gitignore, license) GitHub repo https://github.com/acdh-oeaw/bd-static 
* run `git init` in the root folder of your application bd-static
* execute the commands described under `…or push an existing repository from the command line` in your new created GitHub repo https://github.com/acdh-oeaw/bd-static

## start dev server

* `cd html/`
* `python -m http.server`
* go to [http://0.0.0.0:8000/](http://0.0.0.0:8000/)

## publish as GitHub Page

* go to https://https://github.com/acdh-oeaw/bd-static/actions/workflows/build.yml
* click the `Run workflow` button


## dockerize your application

* To build the image run: `docker build -t bd-static .`
* To run the container: `docker run -p 80:80 --rm --name bd-static bd-static`
* in case you want to password protect you server, create a `.htpasswd` file (e.g. https://htpasswdgenerator.de/) and modifiy `Dockerfile` to your needs; e.g. run `htpasswd -b -c .htpasswd admin mypassword`

### run image from GitHub Container Registry

`docker run -p 80:80 --rm --name bd-static ghcr.io/acdh-oeaw/bd-static:main`

### third-party libraries

the code for all third-party libraries used is included in the `html/vendor` folder, their respective licenses can be found either in a `LICENSE.txt` file or directly in the header of the `.js` file