ROVER_IMAGE := findit-rover:latest
SCHEMA_FILE := apollo/supergraph-schema.graphql

all: generate

generate:
	@echo "🔄 Generating supergraph schema..."
	docker image inspect $(ROVER_IMAGE) &>/dev/null || docker build -t $(ROVER_IMAGE) apollo

	docker run --rm --network findit_backend -v $(PWD)/apollo:/apollo $(ROVER_IMAGE) \
		rover supergraph compose --elv2-license accept --config /apollo/supergraph.yaml > $(SCHEMA_FILE)
	@echo "✅ Generated schema at: $(SCHEMA_FILE)"

clean:
	docker rmi -f $(ROVER_IMAGE) 2>/dev/null || true
	@echo "🧹 Housekeeping!"

soft:
	@docker compose up --build -docker
	@docker compose down elastic kibana apm-server