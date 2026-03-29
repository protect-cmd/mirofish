"""
Simple password-gate auth endpoint
"""

from flask import request, jsonify, current_app
from . import auth_bp


@auth_bp.route('/verify', methods=['POST'])
def verify():
    data = request.get_json(silent=True) or {}
    password = data.get('password', '')

    expected = current_app.config.get('ACCESS_PASSWORD', '')

    # If no password is configured, always succeed (dev mode)
    if not expected:
        return jsonify({'success': True})

    if password == expected:
        return jsonify({'success': True})

    return jsonify({'success': False, 'error': 'Incorrect password'}), 401
