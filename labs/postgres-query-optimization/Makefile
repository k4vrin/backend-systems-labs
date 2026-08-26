.PHONY: up down clean reset smoke plan analyze

up:
	./scripts/up.sh

down:
	./scripts/down.sh

clean:
	./scripts/down.sh --volumes

reset:
	./scripts/reset.sh

smoke:
	./scripts/smoke.sh

plan:
	@test -n "$(QUERY)" || (echo "Usage: make plan QUERY=sql/exercises/file.sql" && exit 2)
	./scripts/run-query.sh plan "$(QUERY)"

analyze:
	@test -n "$(QUERY)" || (echo "Usage: make analyze QUERY=sql/exercises/file.sql" && exit 2)
	./scripts/run-query.sh analyze "$(QUERY)"
