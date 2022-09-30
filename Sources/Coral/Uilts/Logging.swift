import Logging

private var _logger = Logger(label: "app.imink.coral")

var logger: Logger {
    _logger.logLevel = Coral.logLevel
    return _logger
}