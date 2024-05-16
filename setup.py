from setuptools import find_packages, setup

setup(
    name="hyperdirmic",
    version="0.1.0",
    author="Drew White",
    author_email="drew@drew-white.dev",
    description="An OSX app that watches directories and auto-organizes files.",
    long_description=open("README.md").read(),
    long_description_content_type="text/markdown",
    url="https://github.com/drucial/hyperdirmic",
    packages=find_packages(where="src"),
    package_dir={"": "src"},
    include_package_data=True,
    install_requires=[
        "watchdog",
    ],
    classifiers=[
        "Programming Language :: Python :: 3",
        "Operating System :: MacOS :: MacOS X",
        "License :: OSI Approved :: MIT License",
        "Development Status :: 3 - Alpha",
        "Intended Audience :: Developers",
        "Topic :: Software Development :: Build Tools",
    ],
    python_requires=">=3.6",
    entry_points={
        "console_scripts": [
            "hyperdirmic=src.main:main",
        ],
    },
)
