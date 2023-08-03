build_docker:
	docker build -t billie_stats_visualizer .

run_docker:
	docker run -ti \
	    -p 8888:8888 \
	    -v `pwd`/notebook/notebook:/opt/mama.ai/notebook \
	    billie_stats_visualizer bash
