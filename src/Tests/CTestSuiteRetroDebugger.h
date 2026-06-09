#pragma once

#include "CTestSuite.h"
#include <memory>
#include <vector>

class CTest;

void CTestSuiteRegisterRetroDebuggerTests(std::vector<std::unique_ptr<CTest> > &tests);

// RetroDebugger-specific test suite that registers all app tests
class CTestSuiteRetroDebugger : public CTestSuite
{
public:
	CTestSuiteRetroDebugger() {}
	virtual ~CTestSuiteRetroDebugger() {}

	virtual void RegisterTests() override
	{
		CTestSuiteRegisterRetroDebuggerTests(tests);
	}

	// Optional tests = the removable plugins (Fire/Fireworks/Remapper/
	// FlameTiles/Fade). Routes the base-class hook to the plugin registry.
	virtual void SetIncludeOptionalTests(bool include) override;
};
