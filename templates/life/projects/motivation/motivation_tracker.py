#!/usr/bin/env python3
"""
动机追踪 - 成就/连胜/里程碑追踪
"""

import os
import json
from datetime import datetime, timedelta
from pathlib import Path

MOTIVATION_DIR = None
ACHIEVEMENTS_FILE = None
STREAKS_FILE = None
MILESTONES_FILE = None

def detect_workspace():
    """自动检测 workspace 目录"""
    if os.environ.get('WORKSPACE'):
        return os.environ.get('WORKSPACE')
    current = Path.cwd()
    for parent in [current] + list(current.parents):
        if (parent / '.compound-memory.json').exists():
            return str(parent)
    return os.path.expanduser('~/.openclaw/workspace')

def init(workspace=None):
    """初始化动机系统"""
    global MOTIVATION_DIR, ACHIEVEMENTS_FILE, STREAKS_FILE, MILESTONES_FILE
    
    if workspace is None:
        workspace = detect_workspace()
    
    MOTIVATION_DIR = Path(workspace) / 'life' / 'motivation'
    MOTIVATION_DIR.mkdir(parents=True, exist_ok=True)
    
    ACHIEVEMENTS_FILE = MOTIVATION_DIR / 'achievements.json'
    STREAKS_FILE = MOTIVATION_DIR / 'streaks.json'
    MILESTONES_FILE = MOTIVATION_DIR / 'milestones.json'
    
    # 初始化文件
    for file, default in [
        (ACHIEVEMENTS_FILE, {'achievements': {}, 'stats': {'totalAchievements': 0, 'totalPoints': 0}}),
        (STREAKS_FILE, {'streaks': {}}),
        (MILESTONES_FILE, {'milestones': {}})
    ]:
        if not file.exists():
            file.write_text(json.dumps(default, indent=2))

def unlock_achievement(achievement_id, name, description, points=10, icon='🏆'):
    """解锁成就"""
    init()
    
    data = json.loads(ACHIEVEMENTS_FILE.read_text())
    
    if achievement_id in data['achievements']:
        print(f"⚠️ 成就已解锁: {name}")
        return False
    
    achievement = {
        'id': achievement_id,
        'name': name,
        'description': description,
        'points': points,
        'icon': icon,
        'unlocked_at': datetime.now().isoformat()
    }
    
    data['achievements'][achievement_id] = achievement
    data['stats']['totalAchievements'] += 1
    data['stats']['totalPoints'] += points
    
    ACHIEVEMENTS_FILE.write_text(json.dumps(data, indent=2, ensure_ascii=False))
    
    print(f"🏆 成就解锁: {name}")
    print(f"   描述: {description}")
    print(f"   积分: +{points}")
    
    return True

def update_streak(streak_id, name):
    """更新连胜"""
    init()
    
    data = json.loads(STREAKS_FILE.read_text())
    today = datetime.now().strftime('%Y-%m-%d')
    
    # 确保 streaks 键存在
    if 'streaks' not in data:
        data['streaks'] = {}
    
    if streak_id not in data['streaks']:
        data['streaks'][streak_id] = {
            'name': name,
            'current': 1,
            'best': 1,
            'last_date': today,
            'history': [today]
        }
    else:
        streak = data['streaks'][streak_id]
        last_date = streak['last_date']
        
        if last_date == today:
            # 今天已更新
            return streak
        elif last_date == (datetime.now() - timedelta(days=1)).strftime('%Y-%m-%d'):
            # 连续
            streak['current'] += 1
            streak['best'] = max(streak['best'], streak['current'])
            streak['last_date'] = today
            streak['history'].append(today)
        else:
            # 断了
            streak['current'] = 1
            streak['last_date'] = today
            streak['history'] = [today]
    
    data['streaks'][streak_id]['name'] = name  # 更新名称
    STREAKS_FILE.write_text(json.dumps(data, indent=2, ensure_ascii=False))
    
    return data['streaks'][streak_id]

def create_milestone(milestone_id, name, description, target, current=0, unit=''):
    """创建/更新里程碑"""
    init()
    
    data = json.loads(MILESTONES_FILE.read_text())
    
    milestone = {
        'id': milestone_id,
        'name': name,
        'description': description,
        'target': target,
        'current': current,
        'unit': unit,
        'progress': (current / target * 100) if target > 0 else 0,
        'completed': current >= target,
        'updated_at': datetime.now().isoformat()
    }
    
    data['milestones'][milestone_id] = milestone
    MILESTONES_FILE.write_text(json.dumps(data, indent=2, ensure_ascii=False))
    
    if milestone['completed'] and not data['milestones'].get(milestone_id, {}).get('completed', False):
        print(f"🎯 里程碑达成: {name}")
    
    return milestone

def generate_motivation_report():
    """生成动机报告"""
    init()
    
    achievements = json.loads(ACHIEVEMENTS_FILE.read_text())
    streaks = json.loads(STREAKS_FILE.read_text())
    milestones = json.loads(MILESTONES_FILE.read_text())
    
    # 确保必要键存在
    if 'achievements' not in achievements:
        achievements['achievements'] = {}
    if 'stats' not in achievements:
        achievements['stats'] = {'totalAchievements': 0, 'totalPoints': 0}
    if 'streaks' not in streaks:
        streaks['streaks'] = {}
    if 'milestones' not in milestones:
        milestones['milestones'] = {}
    
    report = []
    report.append("# 动机报告")
    report.append(f"生成时间: {datetime.now().strftime('%Y-%m-%d %H:%M')}")
    report.append("")
    
    # 连胜
    report.append("## 🏆 连胜记录")
    for streak_id, streak in streaks['streaks'].items():
        icon = "🔥" if streak['current'] >= 7 else "✨"
        report.append(f"{icon} {streak['name']}: {streak['current']}天 (最高: {streak['best']}天)")
    report.append("")
    
    # 成就
    report.append("## 🎯 成就解锁")
    stats = achievements['stats']
    report.append(f"总计: {stats['totalAchievements']} 个成就, {stats['totalPoints']} 积分")
    for ach_id, ach in list(achievements['achievements'].items())[-5:]:
        report.append(f"{ach['icon']} {ach['name']}: {ach['description']}")
    report.append("")
    
    # 里程碑
    report.append("## 🎯 里程碑进度")
    for ms_id, ms in milestones['milestones'].items():
        if ms['completed']:
            report.append(f"✅ {ms['name']}: {ms['current']}/{ms['target']} {ms['unit']}")
        else:
            bar = "█" * int(ms['progress'] / 10) + "░" * (10 - int(ms['progress'] / 10))
            report.append(f"⏳ {ms['name']}: [{bar}] {ms['progress']:.0f}%")
    
    return '\n'.join(report)

def main():
    init()
    
    # 示例：更新连胜
    update_streak('memory_update', '记忆更新')
    update_streak('task_completion', '任务完成')
    
    # 生成报告
    report = generate_motivation_report()
    print(report)

if __name__ == '__main__':
    main()