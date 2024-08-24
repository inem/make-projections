PROJECTIONS_DIR := ../projections

# Makes it possible to run "make aaa bbb" instead of "make aaa ARGS=bbb"
ARGS = $(filter-out $@,$(MAKECMDGOALS))
%:
	@:

.PHONY: projection clean-projection clean-projection! list-files

projection:
	@if [ -z "$(ARGS)" ]; then \
		echo "Usage: make projection <integration_name>"; \
		exit 1; \
	fi
	@mkdir -p $(PROJECTIONS_DIR)/$(ARGS)
	@find $(PWD) -type f \( -name "*$(ARGS)*" -o -name "*$(shell echo $(ARGS) | sed 's/.*/\u&/')*" \) \
		-not -path "*/node_modules/*" \
		-not -path "*/.git/*" \
		-not -path "*/tmp/*" \
		-not -path "*/log/*" \
		-not -path "*/$(PROJECTIONS_DIR)/*" \
		| while read file; do \
			target_file=$(PROJECTIONS_DIR)/$(ARGS)/$$(basename $$file); \
			if [ ! -e $$target_file ]; then \
				ln -s $$file $$target_file; \
				echo "Created symlink for $$file"; \
			else \
				echo "Symlink already exists for $$file"; \
			fi; \
		done

clean-projection:
	@if [ -z "$(ARGS)" ]; then \
		echo "Usage: make clean-projection <integration_name>"; \
		exit 1; \
	fi
	@echo "Cleaning projection for $(ARGS)..."
	@if [ -d "$(PROJECTIONS_DIR)/$(ARGS)" ]; then \
		files_count=$$(find "$(PROJECTIONS_DIR)/$(ARGS)" -type f | wc -l); \
		if [ $$files_count -gt 0 ]; then \
			echo "Warning: $(PROJECTIONS_DIR)/$(ARGS) contains $$files_count regular file(s). These will not be removed."; \
			echo "Regular files:"; \
			find "$(PROJECTIONS_DIR)/$(ARGS)" -type f -exec echo "  {}" \;; \
		fi; \
		symlinks_count=$$(find "$(PROJECTIONS_DIR)/$(ARGS)" -type l | wc -l); \
		if [ $$symlinks_count -gt 0 ]; then \
			echo "Removing $$symlinks_count symlink(s) from $(PROJECTIONS_DIR)/$(ARGS)"; \
			find "$(PROJECTIONS_DIR)/$(ARGS)" -type l -delete; \
		else \
			echo "No symlinks found in $(PROJECTIONS_DIR)/$(ARGS)"; \
		fi; \
	else \
		echo "Directory $(PROJECTIONS_DIR)/$(ARGS) does not exist. Nothing to clean."; \
	fi

clean-projection!:
	@if [ -z "$(ARGS)" ]; then \
		echo "Usage: make clean-projection! <integration_name>"; \
		exit 1; \
	fi
	@echo "Warning: This will remove ALL files and symlinks in $(PROJECTIONS_DIR)/$(ARGS)"
	@echo "Are you sure you want to continue? [y/N]"
	@read -r response; \
	if [ "$$response" = "y" ] || [ "$$response" = "Y" ]; then \
		if [ -d "$(PROJECTIONS_DIR)/$(ARGS)" ]; then \
			echo "Removing all contents from $(PROJECTIONS_DIR)/$(ARGS)"; \
			rm -rf "$(PROJECTIONS_DIR)/$(ARGS)"; \
			echo "Directory $(PROJECTIONS_DIR)/$(ARGS) has been completely removed."; \
		else \
			echo "Directory $(PROJECTIONS_DIR)/$(ARGS) does not exist. Nothing to clean."; \
		fi; \
	else \
		echo "Operation cancelled."; \
	fi

list-files:
	@if [ -z "$(ARGS)" ]; then \
		echo "Usage: make list-files <integration_name>"; \
		exit 1; \
	fi
	@echo "Files related to $(ARGS):"
	@find . -type f \( -name "*$(ARGS)*" -o -name "*$(shell echo $(ARGS) | sed 's/.*/\u&/')*" \) \
		-not -path "*/node_modules/*" \
		-not -path "*/.git/*" \
		-not -path "*/tmp/*" \
		-not -path "*/log/*" \
		-not -path "*/$(PROJECTIONS_DIR)/*" \
		| sort

open-projection:
	open $(PROJECTIONS_DIR)/$(ARGS)
