# Intro recap about just
help:
	@echo """\nRun just -h if you want some help on the commands \n\
	Type:\tjust --list if you want a list of available recipes. \n\
	Launch:\tjust <recipe_name> if you want to launch a specific recipe.\n"""

# configure and install pre commit tool
install_pre_commit: 
	poetry run pre-commit install

# configure and install pre commit tool
uninstall_pre_commit: 
	poetry run pre-commit uninstall

# Install the poetry and python environment
install:
	echo "🚀 Creating virtual environment using pyenv and poetry"
	poetry install
	poetry shell

# Install the poetry environment
install-poetry:
	echo "🚀 Creating virtual environment using pyenv and poetry"
	poetry install
	poetry shell

# Install the poetry environment
install-pdm:
	echo "🚀 Creating virtual environment using pyenv and PDM"
	pdm install
	pdm use

# Run code quality tools.
check_project:
	echo "🚀 Checking Poetry lock file consistency with 'pyproject.toml': Running poetry lock --check"
	poetry lock --check
	echo "🚀 Linting code: Running pre-commit"
	poetry run pre-commit run -a
# echo "🚀 Checking for obsolete dependencies: Running deptry"
# poetry run deptry .

# Install and configure the poetry plugins
poetry_plugins_install:
	echo "Install poetry-plugin-sort"
	poetry self add poetry-plugin-sort
	poetry self add poetry-plugin-up

# Update the poetry environment
poetry_update:
	echo "🚀 Updating virtual environment using poetry"
	poetry self update

# Launch the poetry plugins
poetry_plugins:
	echo "Launching poetry-plugin-sort"
	poetry sort

# Test the code with pytest.
test:
	echo "🚀 Testing code: Running pytest"
	poetry run pytest --cov --cov-config=pyproject.toml --cov-report=xml tests

# Launch the app/main.py with python3
launch_py3:
	python3 app/main.py

# Launch the app/main.py with normal python
launch_py:
	python app/main.py

# Build wheel file using poetry
build: clean-build #
	echo "🚀 Creating wheel file"
	poetry build

# clean build artifacts
clean-build:
	rm -rf dist

# publish a release to pypi.
publish:
	echo "🚀 Publishing: Dry run."
	poetry config pypi-token.pypi $(PYPI_TOKEN)
	poetry publish --dry-run
	echo "🚀 Publishing."
	poetry publish

# Test if mkdocs documentation can be built without warnings or errors
docs-test:
	poetry run mkdocs build -s

# Launch mkdocs documentation locally
docs_launch:
	poetry run mkdocs serve

# Launch mkdocs documentation locally
docs_launch_normal:
	mkdocs serve -v --config-file mkdocs.yml

# Build mkdocs for local test
docs_build:
	poetry run mkdocs build --clean --quiet --config-file mkdocs.yml

# Launch mkdocs documentation locally with the local building artefacts
docs_launch_local:
	poetry run mkdocs build --clean --quiet --config-file mkdocs.yml
	poetry run mkdocs serve -v --dev-addr=0.0.0.0:8000

# Deploy mkdocs documentation to github pages
docs_deploy:
	@poetry run mkdocs build --clean --quiet --config-file mkdocs.yml
	@poetry run mkdocs gh-deploy --force

# Build mkdocs for official online release
docs_public:
	@poetry run mkdocs build -c -v --site-dir public --quiet --config-file mkdocs.yml

# create the docker network for the project
create_network:
	docker network create appbox

# launch the python application containers
launch:
	docker-compose -p appbox up --build -d 

# launch the backend project containers only
launch_all:
	docker-compose -p appbox up --build -d app

# launch the database container only
launch_db:
	docker-compose -p appbox up --build -d db

# check the status of the docker containers
check:
	docker ps -a | grep "appbox"

# check the logs of the application container
check_logs:
	docker logs -t app

# exec bash in the python app container
check_exec:
	docker exec -it app /bin/bash

# stop all containers
stop:
	docker-compose -p appbox down
	# docker-compose down -v

# stop containers and clean the volumes
stop_clear:
	docker-compose -p appbox down -v

# clean the docker volumes
clean_volumes:
	docker volume prune

# Clean the projects of unwanted cached folders
clean:
	rm -rf **/.ipynb_checkpoints **/.pytest_cache **/__pycache__ **/**/__pycache__ ./notebooks/ipynb_checkpoints .pytest_cache ./dist ./volumes

# Restore the projects to the start (hard clean)
restore:
	rm -rf **/.ipynb_checkpoints **/.pytest_cache **/__pycache__ **/**/__pycache__ ./notabooks/ipynb_checkpoints .pytest_cache ./dist .venv poetry.lock