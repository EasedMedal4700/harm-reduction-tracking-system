import os
import yaml
from typing import Dict, Any, Optional

class CIConfig:
    _instance = None
    _config: Dict[str, Any] = {}

    def __new__(cls):
        if cls._instance is None:
            cls._instance = super(CIConfig, cls).__new__(cls)
            cls._instance._load_config()
        return cls._instance

    def _load_config(self):
        base_dir = os.path.dirname(os.path.abspath(__file__))
        config_path = os.path.join(base_dir, "ci_config.yaml")

        if os.path.exists(config_path):
            with open(config_path, 'r') as f:
                self._config = yaml.safe_load(f) or {}
        else:
            print(f"Warning: Config file not found at {config_path}")
            self._config = {}

    @property
    def config(self) -> Dict[str, Any]:
        return self._config

    def get_step_config(self, step_name: str) -> Dict[str, Any]:
        return self._config.get('pipeline', {}).get('steps', {}).get(step_name, {})

    def is_step_enabled(self, step_name: str) -> bool:
        return self.get_step_config(step_name).get('enabled', True)

    def get_color(self, key: str) -> str:
        return self._config.get('pipeline', {}).get('colors', {}).get(key, 'white')

    def should_show_successes(self) -> bool:
        return self._config.get('pipeline', {}).get('output', {}).get('show_successes', True)

    def should_show_progress(self) -> bool:
        return self._config.get('pipeline', {}).get('output', {}).get('show_progress', True)

class Colors:
    HEADER = '\033[95m'
    BLUE = '\033[94m'
    CYAN = '\033[96m'
    GREEN = '\033[92m'
    YELLOW = '\033[93m'
    RED = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'
    WHITE = '\033[97m'

    @staticmethod
    def get_color_code(color_name: str) -> str:
        color_map = {
            'green': Colors.GREEN,
            'red': Colors.RED,
            'yellow': Colors.YELLOW,
            'blue': Colors.BLUE,
            'cyan': Colors.CYAN,
            'white': Colors.WHITE,
            'neutral': Colors.WHITE
        }
        return color_map.get(color_name.lower(), Colors.WHITE)

    @staticmethod
    def colorize(text: str, color_key: str) -> str:
        config = CIConfig()
        color_name = config.get_color(color_key)
        code = Colors.get_color_code(color_name)
        return f"{code}{text}{Colors.ENDC}"
