#define PY_SSIZE_T_CLEAN
#include <Python.h>

int
main(int argc, char *argv[])
{
    PyObject *pModule, *pVersion;
    const char *version_str;
    char major_minor[6];  // Enough to hold "X.Y\0"

    // Initialize the Python interpreter
    Py_Initialize();

    // Import the sys module
    pModule = PyImport_ImportModule("sys");
    if (pModule != NULL) {
        // Get the version attribute from sys module
        pVersion = PyObject_GetAttrString(pModule, "version");
        if (pVersion && PyUnicode_Check(pVersion)) {
            // Get the version string
            version_str = PyUnicode_AsUTF8(pVersion);

            // Copy only the major and minor version part (e.g., "3.11")
            strncpy(major_minor, version_str, 4);  // Copy "3.11"
            major_minor[4] = '\0';  // Null-terminate the string

            // Print the major.minor version
            printf("%s\n", major_minor);

            Py_DECREF(pVersion);
        } else {
            PyErr_Print();
            fprintf(stderr, "Failed to retrieve Python version\n");
        }
        Py_DECREF(pModule);
    } else {
        PyErr_Print();
        fprintf(stderr, "Failed to load sys module\n");
    }

    // Finalize the Python interpreter
    if (Py_FinalizeEx() < 0) {
        return 120;
    }
    return 0;
}
