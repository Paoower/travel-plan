# 🤝 Contributing to Travel-Plan

Thank you for your interest in contributing to Travel-Plan! This document provides guidelines and instructions for contributing.

---

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Coding Standards](#coding-standards)
- [Commit Message Guidelines](#commit-message-guidelines)
- [Pull Request Process](#pull-request-process)
- [Testing Guidelines](#testing-guidelines)
- [Documentation](#documentation)

---

## 💡 Code of Conduct

### Our Pledge
We are committed to providing a welcoming and inspiring community environment.

### Our Standards
- Use welcoming and inclusive language
- Be respectful of differing opinions and experiences
- Accept constructive criticism gracefully
- Focus on what is best for the community
- Show empathy towards other community members

---

## 🚀 Getting Started

### Prerequisites
- Docker & Docker Compose
- Java 17+
- Maven 3.8.6+
- Git

### Setup Development Environment
```bash
# Clone repository
git clone https://github.com/yourusername/travel-plan.git
cd travel-plan

# Create feature branch
git checkout -b feature/your-feature-name

# Start services
bash start.sh

# Load helpful commands
source commands.sh

# Run tests
mvn clean test
```

---

## 🔄 Development Workflow

### 1. Create Feature Branch
```bash
git checkout -b feature/descriptive-name
```

**Branch Naming Convention**:
- `feature/feature-name` - New features
- `bugfix/bug-name` - Bug fixes
- `docs/documentation-update` - Documentation
- `refactor/refactoring-description` - Code refactoring
- `hotfix/urgent-issue` - Critical fixes

### 2. Make Changes
- Write clean, readable code
- Follow coding standards (see below)
- Add/update tests
- Update documentation

### 3. Commit Changes
```bash
git add .
git commit -m "type: brief description"
```

**Commit Message Format**:
```
type(scope): subject

body

footer
```

**Types**:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation
- `style`: Code style (formatting, missing semicolons, etc)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Build, dependencies, tools

**Example**:
```
feat(auth): implement JWT refresh token endpoint

- Add refresh token generation logic
- Setup token expiration handling
- Add unit tests for refresh endpoint

Closes #123
```

### 4. Push Changes
```bash
git push origin feature/your-feature-name
```

### 5. Create Pull Request
- Go to GitHub and create a Pull Request
- Fill in the PR template
- Request reviewers
- Wait for CI/CD pipeline to pass

---

## 📝 Coding Standards

### Java Code Style

#### Naming Conventions
```java
// Classes: PascalCase
public class UserService { }

// Methods/Variables: camelCase
public void createUser() { }
private String userName;

// Constants: UPPER_SNAKE_CASE
public static final int MAX_RETRIES = 3;

// Interfaces: PascalCase with 'I' prefix (optional)
public interface IUserRepository { }
```

#### Code Organization
```java
public class UserService {
    // 1. Constants
    private static final int MAX_USERS = 1000;
    
    // 2. Instance variables
    @Autowired
    private UserRepository userRepository;
    
    // 3. Constructor
    public UserService(UserRepository repository) {
        this.userRepository = repository;
    }
    
    // 4. Public methods
    public User createUser(CreateUserRequest request) { }
    
    // 5. Private methods
    private void validateUser(User user) { }
}
```

#### Documentation
```java
/**
 * Creates a new user in the system.
 *
 * @param request the user creation request
 * @return the created user
 * @throws UserAlreadyExistsException if user email already exists
 * @throws InvalidUserException if user data is invalid
 */
public User createUser(CreateUserRequest request) {
    // Implementation
}
```

### Formatting
- **Indentation**: 4 spaces
- **Line Length**: Max 100 characters
- **Imports**: Alphabetical order, no wildcard imports

### Best Practices
- ✅ Use dependency injection (Spring)
- ✅ Keep methods small and focused
- ✅ Use meaningful variable names
- ✅ Avoid null pointers (use Optional)
- ✅ Use logging appropriately
- ✅ Write testable code
- ✅ Follow SOLID principles
- ❌ Don't use hardcoded values
- ❌ Don't catch generic exceptions
- ❌ Don't ignore exceptions silently

---

## ✍️ Commit Message Guidelines

### Format
```
<type>(<scope>): <subject>

<body>

<footer>
```

### Type
- `feat` - Feature
- `fix` - Bug fix
- `docs` - Documentation
- `style` - Code style
- `refactor` - Refactoring
- `test` - Tests
- `chore` - Maintenance

### Scope
Component affected (auth, user, travel, payment, gateway)

### Subject
- Imperative mood ("add" not "added")
- Don't capitalize first letter
- No period (.) at the end
- Max 50 characters

### Body
- Explain WHAT and WHY, not HOW
- Wrap at 72 characters
- Separate from subject with blank line
- Use bullet points for multiple changes

### Footer
- Reference issues: `Closes #123`
- Breaking changes: `BREAKING CHANGE: description`

---

## 🔀 Pull Request Process

### Before Creating PR
- [ ] Code follows style guidelines
- [ ] All tests pass locally
- [ ] Code coverage maintained (80%+)
- [ ] Documentation updated
- [ ] No merge conflicts
- [ ] Commit messages follow guidelines

### PR Template
```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Feature
- [ ] Bug fix
- [ ] Documentation
- [ ] Refactoring

## Testing
- [ ] Unit tests added/updated
- [ ] Integration tests added/updated
- [ ] Manual testing completed

## Related Issues
Closes #123

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Documentation updated
- [ ] No new warnings generated
```

### Review Process
1. PR submitted
2. Automated CI/CD runs (build, test, quality)
3. Reviewers review code
4. Address review comments
5. Approval by 2+ reviewers
6. Merge to develop
7. Close related issues

### Review Expectations
- Code review within 24 hours
- Constructive feedback
- Approval when standards met
- Clear communication

---

## 🧪 Testing Guidelines

### Unit Tests
```java
@Test
void testCreateUserSuccessfully() {
    // Arrange
    CreateUserRequest request = new CreateUserRequest("John", "john@example.com");
    
    // Act
    User result = userService.createUser(request);
    
    // Assert
    assertNotNull(result);
    assertEquals("John", result.getName());
    assertEquals("john@example.com", result.getEmail());
}

@Test
void testCreateUserWithDuplicateEmail() {
    // Arrange
    CreateUserRequest request = new CreateUserRequest("Jane", "jane@example.com");
    when(userRepository.existsByEmail("jane@example.com")).thenReturn(true);
    
    // Act & Assert
    assertThrows(UserAlreadyExistsException.class, () -> userService.createUser(request));
}
```

### Test Coverage
- **Minimum**: 80% code coverage
- **Methods**: All public methods tested
- **Edge Cases**: Test boundary conditions
- **Exceptions**: Test error scenarios

### Running Tests
```bash
# Unit tests
mvn clean test

# Integration tests
mvn clean verify

# Coverage report
mvn clean test jacoco:report
# Report location: target/site/jacoco/index.html
```

---

## 📚 Documentation

### Code Documentation
- Add JavaDoc to public methods
- Explain complex logic
- Update README for API changes
- Add examples for new features

### PR Documentation
- Clear description of changes
- Screenshots for UI changes
- Linked issues
- Testing instructions

### Project Documentation
- Update docs/ folder
- Keep README current
- Document new features
- Update API specifications

---

## 🛠️ Development Tools

### Useful Commands
```bash
# Load helper commands
source commands.sh

# Check service health
tp-health

# View logs
tp-logs
tp-logs-service auth-service

# Run tests
tp-test

# Build project
tp-build

# Restart services
tp-restart-service user-service
```

### IDE Setup (IntelliJ IDEA)
1. Open project
2. Mark `src/main/java` as Sources Root
3. Mark `src/test/java` as Test Sources Root
4. Install plugins:
   - Lombok
   - Checkstyle-IDEA
   - SonarLint

### IDE Setup (VS Code)
1. Install extensions:
   - Extension Pack for Java
   - Spring Boot Extension Pack
   - Docker

---

## 📞 Getting Help

### Resources
- Check documentation in `/docs`
- Review existing issues
- Ask in team Slack channel
- Contact project maintainers

### Reporting Issues
1. Check if issue already exists
2. Provide clear description
3. Include steps to reproduce
4. Add relevant logs/screenshots
5. Specify environment (OS, Java version, etc)

---

## ✅ Checklist for Contributors

Before submitting a PR, ensure:
- [ ] Forked the repository
- [ ] Created feature branch
- [ ] Made meaningful commits
- [ ] Added/updated tests
- [ ] Ran tests locally (passed)
- [ ] Updated documentation
- [ ] Followed coding standards
- [ ] Followed commit guidelines
- [ ] Created descriptive PR
- [ ] Linked related issues
- [ ] Passed all CI/CD checks
- [ ] Code reviewed by peers
- [ ] Ready for merge

---

## 🎓 Learning Resources

- [Spring Boot Documentation](https://spring.io/projects/spring-boot)
- [Spring Cloud Guide](https://spring.io/projects/spring-cloud)
- [Google Java Style Guide](https://google.github.io/styleguide/javaguide.html)
- [Clean Code by Robert C. Martin](https://www.amazon.com/Clean-Code-Handbook-Software-Craftsmanship/dp/0132350882)
- [Git Best Practices](https://git-scm.com/book/en/v2)

---

## 🎉 Thank You!

We appreciate your contributions and dedication to making Travel-Plan better!

Happy coding! 🚀
