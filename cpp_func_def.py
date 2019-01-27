#!/usr/bin/env python3

import sys
import argparse
import clang.cindex
from clang.cindex import Index
from clang.cindex import Config


class ClangFuncRangeParser:
    def __init__(self, filepath):
        self.filepath = filepath
        self.index = Index.create()
        # NOTE: for avoid search extra include files
        args = ['-nobuiltininc', '-nostdinc++']
        self.tu = self.index.parse(None, [filepath, *args])
        if not self.tu:
            parser.error("unable to load input")

    def print_func_decl_range_all(self):
        def _lambda(node):
            if (node.kind.name == 'FUNCTION_DECL'):
                if (str(node.extent.start.file) == self.filepath):
                    print("file : %s" % node.extent.start.file)
                    print("function : %s" % node.displayname)
                    print(" from line:%s column:%s" % (node.extent.start.line, node.extent.start.column))
                    print(" to   line:%s column:%s" % (node.extent.end.line, node.extent.end.column))
            return True
        self.traverse(_lambda)

    def print_func_range_all(self):
        def _lambda(node):
            if (any(node.kind.name in s for s in ['FUNCTION_DECL', 'CONSTRUCTOR', 'CXX_METHOD'])):
                if (str(node.extent.start.file) == self.filepath):
                    print("file : %s" % node.extent.start.file)
                    print("function : %s" % node.displayname)
                    print(" from line:%s column:%s" % (node.extent.start.line, node.extent.start.column))
                    print(" to   line:%s column:%s" % (node.extent.end.line, node.extent.end.column))
            return True
        self.traverse(_lambda)

    def print_func_range(self, line):
        found_flag = False

        def _lambda(node):
            nonlocal found_flag
            if (any(node.kind.name in s for s in ['FUNCTION_DECL', 'CONSTRUCTOR', 'CXX_METHOD'])):
                if (str(node.extent.start.file) == self.filepath):
                    if (node.extent.start.line <= line and line <= node.extent.end.line):
                        print("%s %s" % (node.extent.start.line, node.extent.end.line))
                        found_flag = True
                        return False
            return True
        self.traverse(_lambda)
        return found_flag

    def print_all(self):
        def _lambda(node):
            if (True or str(node.extent.start.file) == self.filepath):
                print("file : %s" % node.extent.start.file)
                print("kind : %s" % node.kind.name)
                print("function : %s" % node.displayname)
                print(" from line:%s column:%s" % (node.extent.start.line, node.extent.start.column))
                print(" to   line:%s column:%s" % (node.extent.end.line, node.extent.end.column))
            return True
        self.traverse(_lambda)

    def traverse(self, f):
        self.traverse_body(self.tu.cursor, f)

    def traverse_body(self, node, f):
        ret = f(node)
        if not ret:
            return
        for child in node.get_children():
            ret = self.traverse_body(child, f)
            if not ret:
                break
        return ret


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('-l', '--line', required=True, type=int)
    parser.add_argument('filepath')

    args, extra_args = parser.parse_known_args()

    clang_func_range_parser = ClangFuncRangeParser(args.filepath)
#     clang_func_range_parser.print_all()
#     clang_func_range_parser.print_func_range_all()
#     clang_func_range_parser.print_func_decl_range_all()
    found_flag = clang_func_range_parser.print_func_range(args.line)
    sys.exit(0 if found_flag else 1)
