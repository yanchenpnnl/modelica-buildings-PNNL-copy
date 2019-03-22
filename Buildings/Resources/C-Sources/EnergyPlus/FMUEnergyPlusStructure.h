/*
 * A structure to store the data needed to communicate with EnergyPlus.
 */

#ifndef Buildings_FMUEnergyPlusStructure_h /* Not needed since it is only a typedef; added for safety */
#define Buildings_FMUEnergyPlusStructure_h

#include <stdlib.h>
#include <stddef.h>  /* stddef defines size_t */
#include <string.h>
#include <stdio.h>
#include <execinfo.h>

#include "FMI/fmi_import_context.h"
#include "FMI2/fmi2FunctionTypes.h"
#include "ModelicaUtilities.h"

/* Use windows.h only for Windows */
#ifdef _WIN32
#include <windows.h>
#define WINDOWS 1
#else
#define WINDOWS 0
#define HANDLE void *
/* See http://www.yolinux.com/TUTORIALS/LibraryArchives-StaticAndDynamic.html */
#define _GNU_SOURCE
#include <dlfcn.h>
#endif

#define FMU_EP_VERBOSITY 3 /* Verbosity flag, 0: quiet, 3: all output */

#ifndef max
  #define max( a, b ) ( ((a) > (b)) ? (a) : (b) )
#endif

static char* MOD_BUI_JSON = "ModelicaBuildingsEnergyPlus.json";

void writeLog(unsigned int level, const char* msg);

void logStringArray(unsigned int level,
                    const char* msg,
                    const char** array,
                    size_t n);

void logValueReferenceArray(unsigned int level,
                            const char* msg,
                            const fmi2ValueReference* array,
                            size_t n);


typedef struct FMUBuilding
{
  fmi2_import_t* fmu;
  fmi_import_context_t* context;
  const char* GUID;
  fmi2Byte* name;
  fmi2Byte* weather;
  fmi2Byte* idd;
  char* epLib;
  fmi2Integer nZon; /* Number of zones that use this FMU */
  fmi2Byte** zoneNames; /* Names of zones in this FMU */
  void** zones; /* Pointers to all zones*/
  char* tmpDir; /* Temporary directory used by EnergyPlus */
} FMUBuilding;

typedef struct FMUZone
{
  int index;
  fmi2Byte* name;      /* Name of this zone */
  FMUBuilding* ptrBui; /* Pointer to building with this zone */

  char** parameterNames;
  char** inputNames;
  char** outputNames;

  size_t nParameterValueReferences; /* Number of parameter value references per zone*/
  size_t nInputValueReferences; /* Number of input value references per zone*/
  size_t nOutputValueReferences; /* Number of output value references per zone*/

  fmi2ValueReference* parameterValueReferences; /* Value reference of parameter variables*/
  fmi2ValueReference* inputValueReferences; /* Value reference of input variables*/
  fmi2ValueReference* outputValueReferences; /* Value references of output variables*/

  fmi2Byte** parameterVariableNames; /* Full names of parameter variables (used for reporting only) */
  fmi2Byte** inputVariableNames; /* Full names of input variables (used for reporting only)*/
  fmi2Byte** outputVariableNames; /* Full names of output variables (used for reporting only)*/
} FMUZone;

void fmilogger(jm_callbacks* c, jm_string module, jm_log_level_enu_t log_level, jm_string message);

void getEnergyPlusDLLName(char** epLibName);

void incrementBuildings_nFMU();
void decrementBuildings_nFMU();
unsigned int getBuildings_nFMU();

void buildVariableNames(
  const char* zoneName,
  const char** variableNames,
  const size_t nVar,
  char** *ptrVarNames,
  char** *ptrFullNames);

FMUBuilding* FMUZoneAllocateBuildingDataStructure(
  const char* idfName, const char* weaName,
  const char* iddName,
  const char* zoneName, FMUZone* zone);

FMUBuilding* getBuildingsFMU(size_t iFMU);
void getEnergyPlusTemporaryDirectory(const char* idfName, char** dirNam);

#endif
