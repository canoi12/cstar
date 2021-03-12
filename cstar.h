#ifndef CSTAR_H
#define CSTAR_H

#define CS_VERSION "0.1.0"
#define CS_ASSERT(expr, msg) 

#define CS_API extern

enum {
    CS_LOG = 0,
    CS_ERROR,
    CS_TRACELOG,
    CS_WARNING
};

CS_API int cst_log(int mode, const char *error_msg);
CS_API int cst_tracelog(int mode, const char *error_msg);

#endif /* CSTAR_H */

#if defined(CSTAR_IMPLEMENTATION)

#include <time.h>
#include <stdarg.h>

void cst_log(int type, const char *fmt, ...) {
  time_t t = time(NULL);
  struct tm *tm_now;

  va_list args;

  char err[15] = "";
  if (type == 1) sprintf((char*)err, "ERROR: ");
  char buffer[1024];
  char bufmsg[512];

  tm_now = localtime(&t);
  char buf[10];
  strftime((char*)buf, sizeof(buf), "%H:%M:%S", tm_now);
  fprintf(stderr, "%s %s", buf, err);
  va_start(args, fmt);
  vfprintf(stderr, (const char*)fmt, args);
  va_end(args);
  fprintf(stderr, "\n");
}

void tic_tracelog(int type, const char *file, const char *function, int line, const char *fmt, ...) {
  time_t t = time(NULL);
  struct tm *tm_now;

  va_list args;

  char err[15] = "";
  if (type == 1) sprintf((char*)err, "ERROR in ");
  char buffer[1024];
  char bufmsg[512];

  tm_now = localtime(&t);
  char buf[10];
  strftime((char*)buf, sizeof(buf), "%H:%M:%S", tm_now);
  fprintf(stderr, "%s %s:%d %s%s(): ", buf, file, line, err, function);
  // sprintf(buffer, "%s %s:%d %s%s(): ", buf, file, line, err, function);
  va_start(args, fmt);
  // vsprintf(bufmsg, (const char*)fmt, args);
  vfprintf(stderr, (const char*)fmt, args);
  // fprintf(stderr, "%s", bufmsg);
  va_end(args);
  fprintf(stderr, "\n");
  // tico_input_ok_internal
  // strcat(buffer, bufmsg);
  // tc_editor_write_log(buffer);
}

#if defined(CSTAR_CLI)
int main(int argc, char ** argv) {

    return 0;
}
#endif /* CSTAR_CLI */

#endif /* CSTAR_IMPLEMENTATION */
