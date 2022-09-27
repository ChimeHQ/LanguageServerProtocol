# ``LanguageServerProtocol``

A Swift library for interacting with Language Server Protocol.

## Overview

This is a Swift library for interacting with [Language Server Protocol](https://microsoft.github.io/language-server-protocol/). It contains type definitions and utilities useful for both server- and client-side projects.

If you are looking for a way to interact with servers, you probably want to use the higher-level [LanguageClient](https://github.com/ChimeHQ/LanguageClient).

## Typing Approach

Where possible, this library matches the LSP spec. However, there are some additional types present in this library that aren't in the spec. This is caused by the use of anonymous structures.

This library models these cases using nested structures and/or the ``TwoTypeOption`` and ``ThreeTypeOption`` types.
