// ist package converts an API definition into a Jsonnet Abstract Syntax Tree (AST)
// through an Intermediate Syntax Tree (IST).
package ist

// TODO: Steps to build a full Intermediate Syntax Tree:
//  - Read API definitions
//  - Create a node for each definition
//      - Use specific node for references
//  - Resolve all references
//  ___
//  In order to resolves references, we need to use the full list of all API definitions ... so we resolve
//  this tree lazily. This is why the package will be divided in several parts:
//  - transpiler/ist: contains the node types of the IST
//  - transpiler: compile the naive IST into a full Jsonnet AST
//      > This package resolves and filters the IST nodes. Then, it organizes the API nodes (public & hidden).
//      > Finally, it build the full Jsonnet AST