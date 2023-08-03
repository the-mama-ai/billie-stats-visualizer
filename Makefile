build_docker:
	docker build -t billie_stats_visualizer .

run_docker:
	docker run -ti \
	    -p 8888:8888 \
	    -v C:/Users/akd/Documents/THE_MAMA/Projects/billie_stats_visualizer/notebook/notebook:/opt/mama.ai/notebook \
	    billie_stats_visualizer bash
