ROVER_IMAGE := findit-rover:latest
SCHEMA_FILE := apollo/supergraph-schema.graphql
DOCKER := docker
DOCKER_COMPOSE := docker compose


ifeq ($(TEL),true)
DOCKER_COMPOSE := $(DOCKER_COMPOSE) -f compose.full.yaml
endif			

ifeq ($(PROD),true)
DOCKER_COMPOSE := $(DOCKER_COMPOSE) -f compose.prod.yaml
endif


up:
	$(DOCKER_COMPOSE) up -d --build

schema-generate:
	@echo "🔄 Generating supergraph schema..."
	$(DOCKER) image inspect $(ROVER_IMAGE) > /dev/null 2>&1 || $(DOCKER) build -t $(ROVER_IMAGE) apollo

	$(DOCKER) run --rm --network findit_backend -v $(PWD)/apollo:/apollo $(ROVER_IMAGE) \
		rover supergraph compose --elv2-license accept --config /apollo/supergraph.yaml > $(SCHEMA_FILE)
	@echo "✅ Generated schema at: $(SCHEMA_FILE)"

schema-clean:
	$(DOCKER) rmi -f $(ROVER_IMAGE) 2>/dev/null || true
	@echo "🧹 Housekeeping!"

down:
	$(DOCKER_COMPOSE) down --volumes

clean: down
	$(DOCKER) builder prune -a -f

			
