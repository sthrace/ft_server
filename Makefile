build:
	@docker build -t ft_server .
run:
	@docker run -it --rm -p  80:80 -p 443:443 ft_server