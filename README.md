# billie-stats-visualizer
Dockerized jupyter notebook for retrieving sums of usage values (raw or priced) from billie.

Usage:

1. Clone repo
2. Ensure connectivity to VPN
3. Navigate to repo
4. `make build_docker`
5. `make run_docker`
6. In container: `python -m jupyter notebook --ip=0.0.0.0`
7. Follow instructions in terminal to open notebook in browser.
8. Follow instructions in notebook.

Note: for now, you need to have billie running locally (and checkout the branch `api_expansion_generic_value` first) before the notebook can be used. 
