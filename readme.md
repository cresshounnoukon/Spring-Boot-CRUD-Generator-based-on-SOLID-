## Spring Boot CRUD Generator

This script simplifies the generation of basic CRUD (Create, Read, Update, Delete) functionalities for Spring Boot applications, leveraging ModelMapper for efficient object mapping. The generated code adheres to the **SOLID principles**, promoting maintainability, readability, and flexibility in your application's design.

**SOLID Principles:**

* **Single Responsibility Principle (SRP):** Each class has one primary responsibility, reducing the likelihood of unintended side effects during modifications.
* **Open/Closed Principle (OCP):** New functionalities can be added through extension without modifying existing code.
* **Liskov Substitution Principle (LSP):** Subclasses can be used seamlessly wherever their base classes are expected, ensuring consistency and reliability.
* **Interface Segregation Principle (ISP):** Clients only depend on interfaces they utilize, preventing unnecessary coupling and promoting modularity.
* **Dependency Inversion Principle (DIP):** High-level modules depend on abstractions (interfaces) rather than specific implementations, facilitating loose coupling and easier testing.

**Prerequisites:**

* Java and Maven installed

**Installation:**

1. Download the script (e.g., `crud-generator.sh`).
2. Make the script executable: `chmod +x crud-generator.sh`.

**Dependencies:**

Ensure your project includes the essential dependencies in your `pom.xml` file:

* **Spring Boot Starter Web:** for web functionality
* **Spring Data JPA:** for database access
* **Lombok:** for improved code conciseness and reduced boilerplate (optional, but recommended)
* **ModelMapper:** for object mapping between entities and payloads (**required by this script**)

**Usage:**

The script supports two commands:

* **init:** Initializes the project structure by creating necessary directories.
* **generate:** Generates CRUD functionalities for a specific entity.

**Commands:**

* **init <base_package_name>**:
  - Initializes the project structure within the specified base package (e.g., `com.example.app`).
* **generate <package_name> <class_name>**:
  - Generates CRUD functionalities for an entity within the specified package and class name (e.g., `./crud-generator.sh generate com.example.users User`).

**Example:**

1. **Add dependencies:** Include the required dependencies in your `pom.xml`.
2. **Initialize the project:** `./crud-generator.sh init com.example.app`
3. **Generate CRUD for a User entity:** `./crud-generator.sh generate com.example.users User`

**Generated Folder Structure:**

```
your_project_root/
├── config/
│   └── AppConfig.java (ModelMapper configuration)
├── controllers/
│   └── <class_name>Controller.java (CRUD operations)
├── converters/
│   └── <class_name>Converter.java (entity-payload mapping)
├── entities/
│   └── <class_name>.java (data model)
├── exceptions/
│   └── Error.java (base error class)
│   └── (other exception classes)
├── facades/ (optional)
│   ├── <class_name>Facade.java (simplified CRUD access)
│   └── <class_name>FacadeImpl.java (facade implementation)
├── payloads/
│   ├── requests/
│   │   └── <class_name>Request.java (payload for creating/updating)
│   └── responses/
│       └── <class_name>Response.java (payload for retrieving data)
├── repositories/
│   └── <class_name>Repository.java (Spring Data JPA repository)
└── services/ (optional)
    ├── <class_name>Service.java (business logic)
    └── <class_name>ServiceImpl.java (service implementation)
```

**Note:**

* This script provides a basic structure and might require further customization based on your specific project requirements.
* Remember to replace placeholders like `<base_package_name>` and `<class_name>` with your actual values.

**Additional Considerations:**

* While not mandatory, Lombok is highly recommended for its ability to reduce boilerplate code and enhance code readability.
* Consider implementing additional error handling, validation, and security measures to strengthen your application's robustness.
* Explore the optional `facades` and `services` directories for more advanced project structures and code organization.