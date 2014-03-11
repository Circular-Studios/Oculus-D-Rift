

#include <set>

std::set<void*> createdByD;

void registerDInstance(void* instance) {
	createdByD.insert(instance);
}

void deregisterDInstance(void* instance) {
	createdByD.erase(instance);
}

bool isCreatedByD(void* instance) {
	return (bool) createdByD.count(instance);
}
