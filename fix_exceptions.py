#!/usr/bin/env python3
import re
import sys

def fix_exceptions_in_file(file_path):
    """Fix exception constructor calls to use positional parameters instead of named parameters."""
    
    with open(file_path, 'r') as f:
        content = f.read()
    
    # Pattern to match exception calls with named parameters
    patterns = [
        # ServerException with message and statusCode
        (r'throw ServerException\(\s*message:\s*([^,]+),\s*statusCode:\s*[^)]+\s*\)', r'throw ServerException(\1)'),
        # ServerException with just message
        (r'throw ServerException\(\s*message:\s*([^)]+)\s*\)', r'throw ServerException(\1)'),
        # NetworkException with message
        (r'throw const NetworkException\(\s*message:\s*([^)]+)\s*\)', r'throw const NetworkException(\1)'),
        (r'throw NetworkException\(\s*message:\s*([^)]+)\s*\)', r'throw NetworkException(\1)'),
        # UnauthorizedException with message
        (r'throw const UnauthorizedException\(\s*message:\s*([^)]+)\s*\)', r'throw const UnauthorizedException(\1)'),
        (r'throw UnauthorizedException\(\s*message:\s*([^)]+)\s*\)', r'throw UnauthorizedException(\1)'),
        # ValidationException with message and errors
        (r'throw ValidationException\(\s*message:\s*([^,]+),\s*errors:\s*[^)]+\s*\)', r'throw ValidationException(\1)'),
        # ValidationException with just message
        (r'throw ValidationException\(\s*message:\s*([^)]+)\s*\)', r'throw ValidationException(\1)'),
        # CacheException with message
        (r'throw CacheException\(\s*message:\s*([^)]+)\s*\)', r'throw CacheException(\1)'),
        # AuthenticationException with message
        (r'throw AuthenticationException\(\s*message:\s*([^)]+)\s*\)', r'throw AuthenticationException(\1)'),

        # Failure constructors
        # ServerFailure with message
        (r'ServerFailure\(\s*message:\s*([^)]+)\s*\)', r'ServerFailure(\1)'),
        # NetworkFailure with message
        (r'const NetworkFailure\(\s*message:\s*([^)]+)\s*\)', r'const NetworkFailure(\1)'),
        (r'NetworkFailure\(\s*message:\s*([^)]+)\s*\)', r'NetworkFailure(\1)'),
        # UnauthorizedFailure with message
        (r'UnauthorizedFailure\(\s*message:\s*([^)]+)\s*\)', r'UnauthorizedFailure(\1)'),
        # ValidationFailure with message
        (r'ValidationFailure\(\s*message:\s*([^)]+)\s*\)', r'ValidationFailure(\1)'),
        # CacheFailure with message
        (r'const CacheFailure\(\s*message:\s*([^)]+)\s*\)', r'const CacheFailure(\1)'),
        (r'CacheFailure\(\s*message:\s*([^)]+)\s*\)', r'CacheFailure(\1)'),
        # AuthenticationFailure with message
        (r'AuthenticationFailure\(\s*message:\s*([^)]+)\s*\)', r'AuthenticationFailure(\1)'),
    ]
    
    original_content = content
    
    for pattern, replacement in patterns:
        content = re.sub(pattern, replacement, content, flags=re.MULTILINE | re.DOTALL)
    
    if content != original_content:
        with open(file_path, 'w') as f:
            f.write(content)
        print(f"Fixed exceptions in {file_path}")
        return True
    else:
        print(f"No changes needed in {file_path}")
        return False

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python3 fix_exceptions.py <file_path>")
        sys.exit(1)
    
    file_path = sys.argv[1]
    fix_exceptions_in_file(file_path)
