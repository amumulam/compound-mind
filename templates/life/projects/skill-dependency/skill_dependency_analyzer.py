#!/usr/bin/env python3
"""
技能依赖分析器 - 分析技能之间的依赖关系
"""

import os
import json
import re
from pathlib import Path
from collections import defaultdict

def detect_workspace():
    """自动检测 workspace 目录"""
    # 1. 优先使用环境变量
    if os.environ.get('WORKSPACE'):
        return os.environ.get('WORKSPACE')
    
    # 2. 从当前目录向上查找 .compound-memory.json
    current = Path.cwd()
    for parent in [current] + list(current.parents):
        if (parent / '.compound-memory.json').exists():
            return str(parent)
    
    # 3. 使用默认路径
    return os.path.expanduser('~/.openclaw/workspace')

def find_skill_dependencies(skills_dir):
    """分析技能目录中的依赖关系"""
    dependencies = defaultdict(set)
    
    if not os.path.exists(skills_dir):
        return dependencies
    
    for skill_dir in Path(skills_dir).iterdir():
        if not skill_dir.is_dir():
            continue
        
        skill_name = skill_dir.name
        
        # 检查 SKILL.md
        skill_file = skill_dir / 'SKILL.md'
        if skill_file.exists():
            content = skill_file.read_text(encoding='utf-8')
            
            # 查找依赖声明
            # 格式: dependencies: [skill1, skill2] 或 Depends on: skill1, skill2
            dep_match = re.search(r'(?:dependencies|depends[_\s]on)[:\s]*\[?([^\]\n]+)\]?', content, re.IGNORECASE)
            if dep_match:
                deps = [d.strip() for d in dep_match.group(1).split(',')]
                for dep in deps:
                    if dep:
                        dependencies[skill_name].add(dep)
        
        # 检查 package.json
        pkg_file = skill_dir / 'package.json'
        if pkg_file.exists():
            try:
                pkg = json.loads(pkg_file.read_text())
                for dep in pkg.get('dependencies', {}).keys():
                    if dep.startswith('@') or dep in ['openclaw', 'common']:
                        continue
                    dependencies[skill_name].add(dep)
            except:
                pass
    
    return dependencies

def detect_cycles(dependencies):
    """检测循环依赖"""
    cycles = []
    visited = set()
    rec_stack = set()
    
    def dfs(node, path):
        visited.add(node)
        rec_stack.add(node)
        
        for neighbor in dependencies.get(node, []):
            if neighbor not in visited:
                cycle = dfs(neighbor, path + [node])
                if cycle:
                    return cycle
            elif neighbor in rec_stack:
                # 找到循环
                cycle_start = path.index(neighbor) if neighbor in path else -1
                if cycle_start >= 0:
                    return path[cycle_start:] + [node, neighbor]
        
        rec_stack.remove(node)
        return None
    
    for node in dependencies:
        if node not in visited:
            cycle = dfs(node, [])
            if cycle:
                cycles.append(cycle)
    
    return cycles

def topological_sort(dependencies):
    """拓扑排序，返回加载顺序"""
    in_degree = defaultdict(int)
    all_skills = set(dependencies.keys())
    
    for skill, deps in dependencies.items():
        for dep in deps:
            all_skills.add(dep)
            in_degree[dep] += 0  # 确保所有技能都在 in_degree 中
        in_degree[skill] = in_degree.get(skill, 0)
    
    for skill, deps in dependencies.items():
        for dep in deps:
            if dep in all_skills:
                in_degree[skill] += 1
    
    # Kahn's algorithm
    queue = [s for s in all_skills if in_degree.get(s, 0) == 0]
    result = []
    
    while queue:
        node = queue.pop(0)
        result.append(node)
        
        for skill, deps in dependencies.items():
            if node in deps:
                in_degree[skill] -= 1
                if in_degree[skill] == 0:
                    queue.append(skill)
    
    return result if len(result) == len(all_skills) else None

def generate_dependency_report(dependencies, output_file=None):
    """生成依赖报告"""
    report = []
    report.append("🔍 技能依赖图谱分析")
    report.append("=" * 50)
    
    total_skills = len(set(dependencies.keys()) | set().union(*dependencies.values()))
    report.append(f"📁 发现 {total_skills} 个技能")
    
    # 循环依赖
    cycles = detect_cycles(dependencies)
    report.append(f"🔄 循环依赖: {len(cycles)}")
    for cycle in cycles:
        report.append(f"   ⚠️ {' → '.join(cycle)}")
    
    # 拓扑排序
    load_order = topological_sort(dependencies)
    if load_order:
        report.append(f"📦 可排序: {len(load_order)}/{total_skills}")
        report.append("\n建议加载顺序:")
        for i, skill in enumerate(load_order[:20], 1):
            report.append(f"   {i}. {skill}")
        if len(load_order) > 20:
            report.append(f"   ... 还有 {len(load_order) - 20} 个")
    else:
        report.append("⚠️ 存在循环依赖，无法确定加载顺序")
    
    # 依赖最多
    report.append("\n依赖最多的技能:")
    sorted_deps = sorted(dependencies.items(), key=lambda x: len(x[1]), reverse=True)
    for skill, deps in sorted_deps[:5]:
        report.append(f"   {skill}: {len(deps)} 个依赖")
    
    result = '\n'.join(report)
    
    if output_file:
        Path(output_file).parent.mkdir(parents=True, exist_ok=True)
        Path(output_file).write_text(result)
    
    return result

def main():
    workspace = detect_workspace()
    
    # 检查多个可能的技能目录
    possible_dirs = [
        Path(workspace) / '.openclaw' / 'extensions',
        Path.home() / '.openclaw' / 'extensions',
        Path(workspace) / 'skills'
    ]
    
    all_deps = defaultdict(set)
    for skills_dir in possible_dirs:
        if skills_dir.exists():
            deps = find_skill_dependencies(str(skills_dir))
            for skill, dep_set in deps.items():
                all_deps[skill].update(dep_set)
    
    output_file = Path(workspace) / 'life' / 'archives' / 'skill-dependency-report.md'
    report = generate_dependency_report(all_deps, str(output_file))
    
    print(report)
    print(f"\n报告已保存: {output_file}")

if __name__ == '__main__':
    main()