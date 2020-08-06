.ONESHELL:
SHELL := /bin/bash

SRC = $(wildcard nbs/*.ipynb)

all: nbdev docs

nbdev: $(SRC)
	nbdev_build_lib
	touch nbdev

docs_serve: docs
	cd docs && bundle exec jekyll serve

docs: $(SRC)
	nbdev_build_docs
	touch docs

test:
	nbdev_test_nbs

release: pypi
	nbdev_bump_version

conda-build:
	nbdev_conda_package
	cd conda
	conda build nbdev
	anaconda upload -u fastai ${CONDA_PREFIX}/conda-bld/noarch/*-py_0.tar.bz2
	rm ${CONDA_PREFIX}/conda-bld/noarch/*-py_0.tar.bz2
	cd ..

pypi: dist
	twine upload --repository pypi dist/*

dist: clean
	python setup.py sdist bdist_wheel

clean:
	rm -rf dist

