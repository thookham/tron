# Security Policy

## Supported Versions

The following versions of Tron are currently supported with security updates:

| Version | Supported          | Notes |
| ------- | ------------------ | ----- |
| 13.x.x (current) | :white_check_mark: | Latest fork with Windows 10/11 support |
| 12.0.8+ | :white_check_mark: | Recent upstream versions |
| < 12.0.8 | :x: | Legacy versions - upgrade recommended |

**Recommendation**: Always use the latest release from the [Releases page](https://github.com/thookham/tron/releases).

## Security Considerations

### Running Tron Safely

- **Always run from a trusted source**: Only download Tron from the official [GitHub Releases](https://github.com/thookham/tron/releases) page
- **Administrator privileges**: Tron requires admin rights - review the code before running if concerned
- **Backup your data**: While Tron creates restore points, maintain your own backups
- **Test in a VM first**: For production systems, test in a virtual machine before deployment
- **Review logs**: Check Tron's logs after completion for any issues

### Third-Party Tool Security

Tron includes and downloads various third-party security tools. All tools are:
- Downloaded from official sources via HTTPS
- Industry-standard utilities (Malwarebytes, Kaspersky, CCleaner, etc.)
- Regularly updated to latest versions
- Listed with versions in [README.md](README.md) and [BUILDING.md](BUILDING.md)

## Reporting a Vulnerability

If you discover a security vulnerability in Tron, please report it responsibly:

### How to Report

1. **Do NOT** open a public GitHub issue for security vulnerabilities
2. **Email** the maintainer directly with details:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested fix (if available)
3. **Include** relevant system information:
   - Tron version
   - Windows version
   - Specific stage/tool affected

### What to Expect

- **Initial Response**: Within 48-72 hours acknowledging receipt
- **Investigation**: 1-2 weeks for initial assessment
- **Updates**: Weekly status updates on progress
- **Resolution**: 
  - If accepted: Patch released within 2-4 weeks depending on severity
  - If declined: Explanation provided with reasoning

### Vulnerability Handling Process

1. **Triage**: Assess severity and impact
2. **Fix Development**: Create and test patch
3. **Release**: 
   - Critical: Emergency release within days
   - High: Included in next release (typically 1-2 weeks)
   - Medium/Low: Included in planned releases
4. **Disclosure**: Public disclosure after patch is available
5. **Credit**: Reporter credited in release notes (if desired)

## Security Best Practices for Users

### Before Running Tron

- [ ] Download from official GitHub Releases only
- [ ] Verify package integrity (check file size matches documentation)
- [ ] Review changelog for recent security updates
- [ ] Backup critical data
- [ ] Disconnect from production networks (if applicable)

### During Execution

- [ ] Monitor execution for unexpected behavior
- [ ] Review prompts before accepting
- [ ] Keep execution logs for review

### After Execution

- [ ] Review all logs in `C:\Logs\tron\`
- [ ] Check for any failed operations
- [ ] Verify system stability
- [ ] Review quarantined items before permanent deletion

## Known Security Considerations

### Safe Mode Execution

Some security tools may have reduced effectiveness in Safe Mode. For maximum security scanning:
1. Run initial scan in Safe Mode (cleans persistent threats)
2. Reboot to Normal Mode
3. Run second scan in Normal Mode (catches active threats)

### Network Connectivity

- **Standard Release**: Requires internet during execution to download tools
- **AIO Release**: Can run completely offline after download

### Data Collection

Tron does NOT collect or transmit user data. All operations are local. Third-party tools may have their own telemetry - review individual tool documentation.

## Upstream Security

This fork maintains sync with the upstream [bmrf/tron](https://github.com/bmrf/tron) repository for security updates and improvements.

---

**Last Updated**: 2025-12-01 | Tron v13.2.0
