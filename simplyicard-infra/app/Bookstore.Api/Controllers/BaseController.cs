using Microsoft.AspNetCore.Mvc;

namespace Bookstore.Api.Controllers;

/// <summary>
/// Base controller with common functionality
/// </summary>
[ApiController]
[Produces("application/json")]
public class BaseController : ControllerBase
{
    /// <summary>
    /// Creates a paged response with appropriate headers
    /// </summary>
    /// <typeparam name="T">Type of data</typeparam>
    /// <param name="pagedResult">Paged result data</param>
    /// <returns>IActionResult with paged data and pagination headers</returns>
    protected IActionResult PagedResult<T>(DTOs.PagedResult<T> pagedResult)
    {
        Response.Headers.Append("X-Pagination", System.Text.Json.JsonSerializer.Serialize(new
        {
            pagedResult.PageNumber,
            pagedResult.PageSize,
            pagedResult.TotalRecords,
            pagedResult.TotalPages,
            pagedResult.HasPreviousPage,
            pagedResult.HasNextPage
        }));

        return Ok(pagedResult.Data);
    }
}