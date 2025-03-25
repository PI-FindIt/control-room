# Variáveis
ROVER_IMAGE := findit-rover:latest
SCHEMA_FILE := supergraph-schema.graphql

.PHONY: all generate check reload clean

all: generate reload

# Gera o schema combinado
generate:
	@echo "🔄 Gerando supergraph schema..."
	# build only if not exists
	@docker image inspect $(ROVER_IMAGE) &>/dev/null || \
		cd apollo && \
		docker build -t $(ROVER_IMAGE) -f ./apollo/Dockerfile-rover . && \
		cd ..
	@docker run --rm -v $(PWD)/apollo:/apollo $(ROVER_IMAGE) \
		supergraph compose --elv2-license accept --config /apollo/supergraph.yaml 


	@echo "✅ Schema gerado em: $(SCHEMA_FILE)"


# Recarrega o Apollo Router
reload:
	@echo "🔄 Recarregando Apollo Router..."
	@docker compose kill -s SIGHUP apollo-router
	@echo "✅ Router recarregado!"

# Limpeza
clean:
	@docker rmi $(ROVER_IMAGE) 2>/dev/null || true
	@echo "🧹 Ambiente limpo!"