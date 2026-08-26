.PHONY: up down clean reset smoke plan analyze change

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
	@test -n "$(QUERY)" || (echo "Usage: make plan QUERY=exercises/exercise/query.sql" && exit 2)
	./scripts/run-query.sh plan "$(QUERY)"

analyze:
	@test -n "$(QUERY)" || (echo "Usage: make analyze QUERY=exercises/exercise/query.sql" && exit 2)
	./scripts/run-query.sh analyze "$(QUERY)"

change:
	@test -n "$(SQL)" || (echo "Usage: make change SQL=solutions/exercise/apply.sql" && exit 2)
	./scripts/run-change.sh "$(SQL)"
